// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
// 合约包含以下标准 ERC20 功能：
// balanceOf：查询账户余额。
// transfer：转账。
// approve 和 transferFrom：授权和代扣转账。
// 使用 event 记录转账和授权操作。
// 提供 mint 函数，允许合约所有者增发代币。
// 提示：
// 使用 mapping 存储账户余额和授权信息。
// 使用 event 定义 Transfer 和 Approval 事件。
// 部署到sepolia 测试网，导入到自己的钱包
contract CustomERC20 is IERC20{
    // ======== 基本元信息 ========

    // 代币名称
    string private _name;
    // 代币代码
    string private _symbol;

    // 发行总和
    uint256 private _totalSupply;

    // 代币小数位数
    uint8 private _decimals;

    // 代币发行者
    address private _owner;

    //======== 账户授权映射信息 ========

    // 账户余额映射
    mapping(address account => uint256) private _balances;

    // 授权额度
    mapping(address => mapping(address => uint256)) private _allowances;

    modifier onlyOwner() {
         require(msg.sender == _owner, "Not owner");
        _;
    }


    // 合约地址0x0913De2A9E5FF7A38ee025415B9A3Fa6010c4BD0
    // https://sepolia.etherscan.io/token/0x0913de2a9e5ff7a38ee025415b9a3fa6010c4bd0
    // https://sepolia.etherscan.io/tx/0x0a091349e612bdde9c2c752f36b7b02f927cef2decd30ac3bfb0cc41e8a9c6a8
    constructor(string memory tokenName ,string memory tokenSymbol, uint8 tokenDecimals, uint256 initialSupply) {
        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = tokenDecimals;
        _owner = msg.sender;
        // 铸造代币给部署者
        mint(msg.sender, initialSupply);
    }


    function getOwner() public view returns(address) {
        return _owner;
    }

    /**
     * 获取总代币数量
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function name() public view returns(string memory) {
       return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }





    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) public view returns (uint256) {
        if (account == address(0)) {
            revert("CustomERC20: balance query for the zero address");
        }
        return _balances[account];
    }

    /**
     * 转账
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "invalid address");
        require(_balances[msg.sender] >= value, "Insufficient balance");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * 查询给spender的授权额度
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * 设置授权额度
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _allowances[_owner][spender] = value;
        emit Approval(_owner, spender, value);
        return true;
    }

    /**
     * 使用授权额度转账
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "invalid address");
        require(_balances[from] >= value, "Insufficient balance");
        require(_allowances[from][msg.sender] >= 0, "Insufficient balance");
        // 扣减余额
        _balances[from] -= value;
        _allowances[from][msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }


    // 增发代币
    function mint(address to, uint256 value) public onlyOwner returns(bool){
        require(to != address(0), "invalid address");
        _totalSupply += value;
        _balances[to] += value;
        // 触发 Transfer 事件，from = address(0) 代表铸造
        emit Transfer(address(0), to, value);
        return true;
    }

    // 销毁代币
    function burn(uint256 value) public returns(bool) {
        // 用户只能销毁自己的代币
        // 向零地址转账就是销毁
        require(_balances[msg.sender] > 0, "Insufficient balance");
        // 触发 Transfer 事件，to = address(0) 代表销毁
        _balances[msg.sender] -= value;
        _totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
        return true;
    }



}
