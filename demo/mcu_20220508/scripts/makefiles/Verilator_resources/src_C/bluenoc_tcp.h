#ifndef __BLUENOC_TCP_H__
#define __BLUENOC_TCP_H__

#ifndef MSG_NOSIGNAL
 #define MSG_NOSIGNAL (0)
#endif

#ifndef MSG_DONTWAIT
 #define MSG_DONTWAIT (0)
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* These functions are useful for interacting with the
 * BlueNoC <-> TCP bridge from the host software side.
 */

/* Connect to BlueNoC <-> TCP bridge listening at a given address and port.
 * Returns -1 on error or a socket descriptor number on success. The socket
 * descriptor number is used as the fd argument in other API calls.
 */
extern int connect_to_bluenoc_tcp_bridge(const char* addr, unsigned int port);

/* Blocking send of a message on the given socket. The message buffer buf
 * must contain a complete, correctly formatted BlueNoC message.
 */
extern void send_msg(int fd, unsigned int bytes_per_beat, const char* buf);

/* Blocking receive of a message on the given socket. The message buffer buf
 * must be large enough to contain the message received, including header
 * data and padding. Returns a negative number on error. When a message
 * is successfully received, the message (including header) is written
 * into buf and the payload length is returned.
 */
extern int recv_msg(int fd, unsigned int bytes_per_beat, char* buf);

/* Check to see if there is any data to be received.
 * Returns 1 if there is pending message data, 0 if there is none,
 * and -1 on error.
 * NOTE: is_data_pending() returning 1 does *NOT* guarantee that
 *       recv_msg will not block! It only means the start of a
 *       message is available but does not guarantee a complete
 *       message is ready to be received.
 */
extern int is_data_pending(int fd);

/* Print a message, for debugging */
extern void print_msg(unsigned int bytes_per_beat, const char* buf);

/* Disconnect from the BlueNoC <-> TCP bridge on the given socket */
extern void disconnect_from_bluenoc_tcp_bridge(int fd);

/* These functions are used by the BlueNoC <-> TCP bridge hardware
 * implementation module, via import "BDPI".
 */

extern unsigned int bluenoc_open_tcp_socket( unsigned int tcp_port );
extern void         bluenoc_close_tcp_socket( unsigned int socket_descriptor );
extern char         bluenoc_send_tcp_beat( unsigned int  socket_descriptor
                                         , char          beat_size
                                         , char          bytes_already_sent
                                         , unsigned int* beat_value
                                         );
extern void         bluenoc_recv_tcp_beat( unsigned int* return_tuple
                                         , unsigned int  socket_descriptor
                                         , char          beat_size
                                         , char          bytes_already_received
                                         , unsigned int* beat_value_so_far
                                         );

#ifdef __cplusplus
}
#endif

#endif /* __BLUENOC_TCP_H__ */
