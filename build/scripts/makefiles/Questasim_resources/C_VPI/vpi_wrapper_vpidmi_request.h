#ifndef __vpi_wrapper_vpidmi_request_h__
#define __vpi_wrapper_vpidmi_request_h__

#include <vpi_user.h>

/* registration function */
void vpidmi_request_vpi_register();

/* VPI wrapper function */
PLI_INT32 vpidmi_request_calltf(PLI_BYTE8 *user_data);

#endif /* ifndef __vpidmi_request__ */
