#ifndef __vpi_wrapper_vpidmi_response_h__
#define __vpi_wrapper_vpidmi_response_h__

#include <vpi_user.h>

/* registration function */
void vpidmi_response_vpi_register();

/* VPI wrapper function */
PLI_INT32 vpidmi_response_calltf(PLI_BYTE8 *user_data);

#endif /* ifndef __vpidmi_response__ */
