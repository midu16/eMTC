//
// Copyright 2010 Ettus Research LLC
// Copyright 2018 Ettus Research, a National Instruments Company
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#include <uhd/device.hpp>
#include <uhd/utils/safe_main.hpp>
#include <boost/format.hpp>
#include <boost/program_options.hpp>
#include <cstdlib>
#include <iostream>
#include "stare_dispozitiv.h"
/*
namespace {
//! Conditionally append find_all=1 if the key isn't there yet
uhd::device_addr_t append_findall(const uhd::device_addr_t& device_args)
{
    uhd::device_addr_t new_device_args(device_args);
    if (!new_device_args.has_key("find_all")) {
        new_device_args["find_all"] = "1";
    }

    return new_device_args;
}
} // namespace*/

namespace po = boost::program_options;

int UHD_SAFE_MAIN(int argc, char* argv[])
{
	devices_found(argc, argv);
	return 0;
}
