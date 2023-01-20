use libc::{c_int, dlsym, sockaddr_in, socklen_t, RTLD_NEXT};
use std::{ffi::CString, mem::transmute};

#[no_mangle]
extern "C" fn connect(
    sock: *const c_int,
    addr: *const sockaddr_in,
    addrlen: *const socklen_t,
) -> c_int {
    let addr: &sockaddr_in = unsafe { &*(addr as *const sockaddr_in) };
    let mut addr = *addr;
    if let Some(port) = match addr.sin_addr.s_addr.to_be() {
        0x7f000001 if addr.sin_port.to_be() == 443 => Some(4434_u16),
        0x7f000002 if addr.sin_port.to_be() == 80 => Some(8282_u16),
        _ => None,
    } {
        addr.sin_port = port.to_be();
        addr.sin_addr.s_addr = 0x7f000001_u32.to_be();
    }

    let connect_ptr = unsafe { dlsym(RTLD_NEXT, CString::new("connect").unwrap().into_raw()) };
    let libc_connect: fn(*const c_int, *const sockaddr_in, *const socklen_t) -> c_int =
        unsafe { transmute(connect_ptr) };

    libc_connect(
        sock,
        Box::into_raw(Box::new(addr)) as *const sockaddr_in,
        addrlen,
    )
}

