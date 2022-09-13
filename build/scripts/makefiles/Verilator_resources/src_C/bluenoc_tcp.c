#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <poll.h>
#include <netdb.h>

#include "bluenoc_tcp.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Host-side user-visible API */

int connect_to_bluenoc_tcp_bridge(const char* addr, unsigned int port)
{
  struct addrinfo hints;
  struct addrinfo *result, *rp;
  int  s;
  char service[12];
  int socket_fd;

  /* Obtain address(es) matching host/port */

  memset(&hints, 0, sizeof(struct addrinfo));
  hints.ai_family = AF_INET;
  hints.ai_socktype = SOCK_STREAM;  /* TCP/IP socket */
  hints.ai_flags = 0;
  hints.ai_protocol = 0;          /* Any protocol */

  sprintf(service, "%d", port);
  s = getaddrinfo(addr, service, &hints, &result);
  if (s != 0) {
    fprintf(stderr, "Error: getaddrinfo() failed: %s\n", gai_strerror(s));
    return -1;
  }

  /* getaddrinfo() returns a list of address structures.
     Try each address until we successfully connect(2).
     If socket(2) (or connect(2)) fails, we (close the socket
     and) try the next address. */

  for (rp = result; rp != NULL; rp = rp->ai_next) {
    socket_fd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
    if (socket_fd == -1)
      continue;

    if (connect(socket_fd, rp->ai_addr, rp->ai_addrlen) != -1)
      break;                  /* Success */

    close(socket_fd);
  }

  if (rp == NULL) {               /* No address succeeded */
    fprintf(stderr, "Error: connect() failed\n");
    return -1;
  }

  freeaddrinfo(result);           /* No longer needed */

  // Set NODELAY socket option to disable Nagle algorithm
  int one = 1;
  s = setsockopt(socket_fd, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one));

  return socket_fd;
}

void send_msg(int fd, unsigned int bytes_per_beat, const char* buf)
{
  if (buf == NULL) {
    fprintf(stderr,"send_msg: buffer pointer is NULL\n");
    return;
  }
  size_t len = ((size_t)buf[2]) & (size_t)0xff;
  unsigned int bytes_in_last_beat = (4 + len) % bytes_per_beat;
  unsigned int padding = (bytes_in_last_beat == 0) ? 0 : (bytes_per_beat - bytes_in_last_beat);
  ssize_t res = 0;
  while (1) {
    res = send(fd, buf, 4 + len + padding, MSG_NOSIGNAL);
    if (res >= 0)
      break;
    if (errno != EINTR) {
      perror("send_msg");
      break;
    }
  }
}

int recv_msg(int fd, unsigned int bytes_per_beat, char* buf)
{
  if (buf == NULL) {
    fprintf(stderr,"recv_msg: buffer pointer is NULL\n");
    return -2;
  }
  ssize_t res;
  size_t pos = 0;
  int got_header = 0;
  while (1) {
    res = recv(fd, buf + pos, 4 - pos, MSG_WAITALL);
    if (res == (4 - pos)) {
      got_header = 1;
      break;
    }
    else if (res > 0) {
      pos += res;
    }
    else if ((res < 0) && (errno != EINTR))
      break;
  }

  if (!got_header)
    return -1;

  unsigned int len = ((unsigned int)(buf[2])) & 0xff;
  if (len == 0)
    return 0;

  unsigned int bytes_in_last_beat = (4 + len) % bytes_per_beat;
  unsigned int padding = (bytes_in_last_beat == 0) ? 0 : (bytes_per_beat - bytes_in_last_beat);
  pos = 0;
  while (1) {
    res = recv(fd, buf + 4 + pos, len + padding - pos, MSG_WAITALL);
    if (res == (len + padding - pos)) {
      return len;
    }
    else if (res > 0) {
      pos += res;
    }
    else if ((res < 0) && (errno != EINTR))
      return -1;
  }

  return -3; /* control should never reach here */
}

int is_data_pending(int fd)
{
  struct pollfd pfd;
  int n;

  while (1) {
    pfd.fd = fd;
    pfd.events = POLLIN;
    pfd.revents = 0;

    n = poll(&pfd, 1, 0);
    if ((n < 0) && (errno != EINTR))
    {
#if defined(GNU_SOURCE) && (_POSIX_C_SOURCE < 200112L) && (_XOPEN_SOURCE < 600)
      char buf[1024];
      char *err = strerror_r(errno, buf, 1024);
#else
      char err[1024];
      if (strerror_r(errno, err, 1024) != 0)
        strcpy(err, "Unknown error");
#endif
      fprintf (stderr, "Error: poll failed on socket %0d\n%s\n", fd, err);
      return -1;
    }
    else if (n >= 0)
      return n;
  }
  return -1; /* control should never reach this statement */
}

void print_msg(unsigned int bytes_per_beat, const char* buf)
{
  unsigned int dst       = ((unsigned int)(buf[0])) & 0xff;
  unsigned int src       = ((unsigned int)(buf[1])) & 0xff;
  unsigned int len       = ((unsigned int)(buf[2])) & 0xff;
  unsigned int dont_wait = buf[3] & 0x1;
  unsigned int opcode    = (buf[3] >> 2) & 0x3f;
  printf("dst: %d src: %d %d bytes opcode: %x", dst, src, len, opcode);
  if (dont_wait)
    printf(" DW\n");
  else
    printf("\n");
  if (len == 0)
    return;
  unsigned int pos = 4 % bytes_per_beat;
  if (bytes_per_beat > 4)
    printf("            ");
  for (unsigned int n = 0; n < len; ++n) {
    printf("%02x ", (unsigned int)buf[n + 4] & 0xff);
    pos += 1;
    if (pos == bytes_per_beat) {
      printf("\n");
      pos = 0;
    }
  }
  if (pos != 0)
    printf("\n");
}

void disconnect_from_bluenoc_tcp_bridge(int fd)
{
  int res;
  char buf[128];

  /* shut down the socket for writing */
  shutdown(fd, SHUT_WR);

  /* then, read data from the socket until it returns 0,
   * indicating all data from the other side has been
   * received.
   */
  while (1) {
    res = recv(fd, buf, 128, 0);
    if (res == 0)
      break;
    if ((res == -1) && (errno != EINTR))
      break;
  }

  /* finally, close the socket */
  close(fd);
}

/* HW-side routines used through import "BDPI" to implement the
 * bridge
 */

/* Open a TCP port and block waiting for a client to connect
 * to the port.
 */
unsigned int bluenoc_open_tcp_socket( unsigned int tcp_port )
{
    struct addrinfo hints, *result, *rp;
    int s;

    struct sockaddr from_addr;
    int sfd, sfd2;
    socklen_t from_addr_len;

    char port_str[12];

    sfd = -1;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;    /* For wildcard IP address */
    hints.ai_protocol = 0;
    hints.ai_canonname = NULL;
    hints.ai_addr = NULL;
    hints.ai_next = NULL;

    sprintf(port_str, "%d", tcp_port);
    s = getaddrinfo(NULL, port_str, &hints, &result);
    if (s != 0) {
        fprintf(stderr, "Error: getaddrinfo(): %s\n", gai_strerror(s));
        return -1;
    }

    /* getaddrinfo() returns a list of address structures.
     * Try each address until we successfully bind(2).
     * If socket(2) (or bind(2)) fails, we (close the socket
     * and) try the next address.
     */

    for (rp = result; rp != NULL; rp = rp->ai_next) {
        sfd = socket(rp->ai_family, rp->ai_socktype,
                     rp->ai_protocol);
        if (sfd == -1)
            continue;

        int one = 1;
        if (setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)) == -1)
            perror("setsockopt");

        if (setsockopt(sfd, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one)) == -1)
            perror("setsockopt");

        if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
            break;                  /* Success */
        perror("bind");

        close(sfd);
    }

    if (rp == NULL) {               /* No address succeeded */
        fprintf(stderr, "Error: bind() failed at port %d\n", tcp_port);
        return -1;
    }

    freeaddrinfo(result);           /* No longer needed */

    /* Start listening for the client's connection
     * The second arg is 1 because we're only expecting a single client
     */
    s = listen(sfd, 1);
    if (s < 0) {
        fprintf(stderr, "Error: listen() failed on socket %0d at port %d\n",
                sfd, tcp_port);
        return -1;
    }

    /* Accept a connection from the client */
    from_addr_len = sizeof(from_addr);
    sfd2 = accept(sfd, &from_addr, &from_addr_len);
    if (sfd2 < 0) {
        fprintf(stderr, "Error: accept() failed on socket %0d at port %d\n",
                sfd, tcp_port);
        return -1;
    }

    /* Typical general-purpose servers do a fork() at this point to have the
     * child process handle this connection while the parent listens for
     * more connections, but here we are not expecting any more connections
     * so we don't fork a new process
     */

    close(sfd);  /* not needed any more */

    return ((unsigned int)sfd2);
}

/* Close an open TCP socket */
void bluenoc_close_tcp_socket( unsigned int socket_descriptor )
{
  char buf[128];
  ssize_t n;

  /* first, shut down the socket for writing */
  shutdown(socket_descriptor, SHUT_WR);

  /* then, read data from the socket until it returns 0,
   * indicating all data from the other side has been
   * received.
   */
  while (1) {
    n = recv(socket_descriptor, buf, 128, 0);
    if (n == 0)
      break;
    if ((n == -1) && (errno != EINTR))
      break;
  }

  /* finally, close the socket */
  close(socket_descriptor);
}

/* Send beat data through a TCP socket. The bytes sent will begin at
 * beat_value[beat_size - bytes_to_send] and continue through
 * beat_value[beat_size-1]. The maximum allowed value of beat_size is
 * 16. Returns the number of bytes sent, which may be less than
 * bytes_to_send.
 */
char bluenoc_send_tcp_beat( unsigned int  socket_descriptor
                          , char          beat_size
                          , char          bytes_to_send
                          , unsigned int* beat_value
                          )
{
  ssize_t n;
  unsigned char* byte_buf = (unsigned char*) beat_value;

  if ((beat_size > 16) || (bytes_to_send == 0) || (bytes_to_send > beat_size))
    return 0;

  n = send(socket_descriptor, byte_buf + beat_size - bytes_to_send, bytes_to_send, MSG_DONTWAIT);

  if (n < 0) {
    if ((errno == EINTR) || (errno == EAGAIN) || (errno == EWOULDBLOCK)) {
      n = 0;
    }
    else {
      perror("bluenoc_send_tcp_beat");
      bluenoc_close_tcp_socket(socket_descriptor);
      exit(0);                  /* let this be a normal exit */
    }
  }

  return n;
}

/* Receive beat data through a TCP socket.  The return value is
 * returned by pointer through the first argument.  It is a tuple in
 * which the first byte is a count of the number of bytes added to the
 * beat and the remaining bytes are the beat buffer data. If the tuple
 * is (n,beat), then beat is equal to beat_value_so_far[0]
 * through beat_value_so_far[bytes_already_received - 1] as the low bytes
 * followed by n bytes of new data received from the TCP socket.
 * beat_value_so_far is allowed to be NULL, but it should not
 * overlap with the return_tuple buffer.
 */
void bluenoc_recv_tcp_beat( unsigned int* return_tuple
                          , unsigned int  socket_descriptor
                          , char          beat_size
                          , char          bytes_already_received
                          , unsigned int* beat_value_so_far
                          )
{
  ssize_t n;
  unsigned char* byte_buf_in    = (unsigned char*) beat_value_so_far;
  unsigned char* byte_count_out = (unsigned char*) return_tuple;
  unsigned char* byte_buf_out   = byte_count_out + 1;

  if ((beat_size > 16) || (bytes_already_received >= beat_size)) {
    *byte_count_out = 0;
    return;
  }

  if ((byte_buf_in != NULL) && (bytes_already_received > 0))
    memcpy(byte_buf_out,byte_buf_in,bytes_already_received);

  n = recv(socket_descriptor, byte_buf_out + bytes_already_received, beat_size - bytes_already_received, MSG_DONTWAIT);

  if (n < 0) {
    if (errno == EINTR || errno == EAGAIN)
      *byte_count_out = 0;
    else {
      /* this is a fatal recv error */
      perror("bluenoc_recv_tcp_beat");
      bluenoc_close_tcp_socket(socket_descriptor);
      exit(0);                  /* let this be a normal exit */
    }
  }
  else if (n == 0) {
    /* this is an indication that the other end of the connection has
     * shut down
     */
    bluenoc_close_tcp_socket(socket_descriptor);
    exit(0);
  }
  else {
    *byte_count_out = n;
  }

}

#ifdef __cplusplus
}
#endif
