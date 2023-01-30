/**
 * Author: GKing
 * Date: 2022-07-14 02:47:54
 * @LastEditors: GKing
 * @LastEditTime: 2023-01-09 13:36:31
 * Description: 
 * TODO: 
 */
// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

import './interfaces/IUniswapV2Factory.sol';
import './UniswapV2Pair.sol';

// UniswapV2 工厂合约
contract UniswapV2Factory is IUniswapV2Factory {
    // 收税地址
    address public feeTo;
    // 收税地址的设置地址
    address public feeToSetter;
    // 配对映射，地址 => (地址 => 地址)
    mapping(address => mapping(address => address)) public getPair;
    // 所有配对数据数组
    address[] public allPairs;
    // 事件：配对创建
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /**
     * @dev: 构造方法
     * @param: _feeToSetter 收税地址的设置地址
     * @return none
     */      
    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }
    /** 
     * @dev: 查询配对数组长度
     * @return {uint}
     */    
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IUniswapV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
