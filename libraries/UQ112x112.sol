/**
 * @Author: GKing
 * @Date: 2023-01-30 11:10:13
 * @LastEditors: GKing
 * @LastEditTime: 2023-01-30 11:10:36
 * @Description: a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
 * @TODO: 
 */
// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}