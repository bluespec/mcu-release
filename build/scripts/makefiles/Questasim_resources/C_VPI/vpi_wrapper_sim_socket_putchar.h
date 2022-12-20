#ifndef __vpi_wrapper_sim_socket_putchar_h__
#define __vpi_wrapper_sim_socket_putchar_h__

#include <vpi_user.h>

/* registration function */
void socket_putchar_vpi_register();

/* VPI wrapper function */
PLI_INT32 socket_putchar_calltf(PLI_INT32 *user_data);

#endif /* ifndef __vpi_wrapper_sim_socket_putchar_h__ */
