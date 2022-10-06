#ifndef __vpi_wrapper_sim_socket_accept_h__
#define __vpi_wrapper_sim_socket_accept_h__

#include <vpi_user.h>

/* registration function */
void socket_accept_vpi_register();

/* VPI wrapper function */
PLI_INT32 socket_accept_calltf(PLI_INT32 *user_data);

#endif /* ifndef __vpi_wrapper_sim_socket_accept_h__ */
