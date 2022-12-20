#include <stdlib.h>
#include <vpi_user.h>
#include "bdpi.h"

/* the type of the wrapped function */
int vpidmi_request(int, int, int, int);

PLI_INT32 vpidmi_request_calltf(PLI_BYTE8 *user_data)
{
  vpiHandle hCall;
  int arg_1;
  int arg_2;
  int arg_3;
  int arg_4;
  int vpi_result;
  vpiHandle *handle_array;
  
  /* retrieve handle array */
  hCall = vpi_handle(vpiSysTfCall, 0);
  handle_array = vpi_get_userdata(hCall);
  if (handle_array == NULL)
  {
    vpiHandle hArgList;
    hArgList = vpi_iterate(vpiArgument, hCall);
    handle_array = malloc(sizeof(vpiHandle) * 2u);
    handle_array[0u] = hCall;
    handle_array[1u] = vpi_scan(hArgList);
    handle_array[2u] = vpi_scan(hArgList);
    handle_array[3u] = vpi_scan(hArgList);
    handle_array[4u] = vpi_scan(hArgList);
    vpi_put_userdata(hCall, handle_array);
    vpi_put_userdata(hCall, handle_array);
    vpi_free_object(hArgList);
  }
  
  /* create return value */
  make_vpi_result(handle_array[0u], &vpi_result, DIRECT);
  
  /* copy in argument values */
  get_vpi_arg(handle_array[1u], &arg_1, DIRECT);
  get_vpi_arg(handle_array[2u], &arg_2, DIRECT);
  get_vpi_arg(handle_array[3u], &arg_3, DIRECT);
  get_vpi_arg(handle_array[4u], &arg_4, DIRECT);

  
  /* call the imported C function */
  vpi_result = vpidmi_request(arg_1,arg_2,arg_3,arg_4);
  
  /* copy out return value */
  put_vpi_result(handle_array[0u], &vpi_result, DIRECT);
  
  /* free argument storage */
  free_vpi_args();
  vpi_free_object(hCall);
  
  return 0;
}

PLI_INT32 vpidmi_request_sizetf(PLI_BYTE8 *user_data)
{
  return 32u;
}

/* VPI wrapper registration function */
void vpidmi_request_vpi_register()
{
  s_vpi_systf_data tf_data;
  
  /* Fill in registration data */
  tf_data.type = vpiSysFunc;
  tf_data.sysfunctype = vpiSizedFunc;
  tf_data.tfname = "$vpidmi_request";
  tf_data.calltf = vpidmi_request_calltf;
  tf_data.compiletf = 0u;
  tf_data.sizetf = vpidmi_request_sizetf;
  tf_data.user_data = "$vpidmi_request";
  
  /* Register the function with VPI */
  vpi_register_systf(&tf_data);
}
