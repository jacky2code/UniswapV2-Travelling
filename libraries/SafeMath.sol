/**
 * @Author: GKing
 * @Date: 2023-01-30 11:07:50
 * @LastEditors: GKing
 * @LastEditTime: 2023-01-30 11:11:44
 * @Description: a library for performing overflow-safe math, 
 * courtesy of DappHub (https://github.com/dapphub/ds-math)
 * @TODO: 
 */
 
// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}