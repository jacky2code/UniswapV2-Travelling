# Uniswap 全链通

## Prepare 准备物料

- [白皮书中文翻译](https://github.com/yeefea/uniswap-whitepapers-cn/blob/master/uniswap_v2.md) 

- Contracts 合约

  - Router Contract 路由合约

    Find the Router Contract 查找路由合约

    - etherscan 标题栏 more-燃料搜索器中查找 Uniswap V2: Router 2
    - Search "Uniswap V2: Router 2" directly 或者直接搜索：Uniswap V2: Router 2
    - Contract address 合约地址为：0x7a250d5630b4cf539739df2c5dacb4c659f2488d
  
  - Factory Contract 工厂合约
  
    查找到路由合约后，在路由主合约中的构造方法第一个参数就是工厂合约地址
    
    ```bash
    0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f
    ```
    
    <img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2023/01/07/20230107163715.png" align ="left" alt="image-20230107163706523" style="zoom:50%;" />
    
  - 配对合约
  
  - weth合约
  
    0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
  
  - multicall 合约
  
- 合约结构

  UniswapV2ERC20 --继承--> UniswapV2Pair --引用--> UniswapV2Factory

- 创建流动性

  项目方 -- 创建流动性 --> UniswapV2Router -- 调用--> UniswapV2Factory -- 部署--> UniswapV2Pair

- 交易

  用户 --交易--> UniswapV2Router --调用--> uniswapV2Pair

- Uniswap 运行逻辑

  1. Uniswap 核心合约分为3个合约，工厂合约，配对合约，ERC20合约
  2. 核心合约部署时只需要部署工厂合约
  3. 工厂合约部署时，构造函数只需要设定一个手续费管理员
  4. 在工厂合约部署之后，就可以进行创建配对的操作
  5. 要在交易所中进行交易，操作顺序是：创建交易对，添加流动性，交易
  6. 添加配对时需要提供两个token地址，随后工厂合约会为这个交易对部署一个新的配对合约
  7. 配对合约的部署时通过 create2 的方法
  8. 两个 token 的地址按2进制大小排序后一起进行 hash，以这个hash值作为 create2的salt 进行部署
  9. 所以配对合约的地址是可以通过两个 token 地址进行 create2 计算的
  10. 用户可以将两个 token 存入到配对合约中，然后在配对合约中为用户生成一种兼容ERC20的 token 
  11. 配对合约中生成的 ERC20 token 可以成为流动性
  12. 用户可以将自己的流动性余额兑换成配对和与众的任何一种token
  13. 用户也可以取出流动性，配对合约将销毁流动性，并将两种token同时返还用户
  14. 返还的数量将根据流动性数量和两种token的储备量重新计算，如果有手续费收益，用户也将得到收益
  15. 用户可以通过一种token交换另一种token，配对合约将扣除千分之3的手续费
  16. 在 Uniswap 核心合约基础上，还有一个路由合约用来更好的操作核心合约
  17. 路由合约拥有3部分操作方法，添加流动性，移除流动性，交换
  18. 虽然配对合约已经完成所有的交易操作，但路由合约将所有操作整合，配合前端更好的完成交易
  19. 因为路由合约的代码量较多，部署时会超过gas限制，所以路由合约被分为2个文件，功能互相补充。
  
- 知识点
  
  - 快速找到uniswap合约地址
  - weth功能，其他链对应的合约
  - multacall 功能
  
- 前端

  - uniswap 前端
  - uniswap - sdk
  - 知识点
    - 从 github 找到历史提交 



## Contracts Explanation 合约解释

### UniswapV2Factory 工厂合约

#### Variables and Events 变量和事件

```solidity
// 收税地址
address public feeTo;
// 收税地址的设置地址
address public feeToSetter;
// 配对映射，地址 => (地址 => 地址)
mapping(address => mapping(address => address)) public getPair;
// 所有配对数据数组
address[] public allPairs;
// 事件：配对创建
// pair: 配对合约部署到的地址
// uint: 所有配对合约的长度，即 allpaires 长度。
// 获取配对合约序号，如第一个创建的配对合约，序号为 (allPairs.length) 1;
event PairCreated(address indexed token0, address indexed token1, address pair, uint);
```



