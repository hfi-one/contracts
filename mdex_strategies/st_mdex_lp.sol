pragma solidity >=0.7.0;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account)
        internal
        pure
        returns (address payable)
    {
        return address(uint160(account));
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender).add(value);
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender).sub(
                value,
                "SafeERC20: decreased allowance below zero"
            );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

//
interface IController {
    function withdraw(address, uint256) external;

    function balanceOf(address) external view returns (uint256);

    function earn(address, uint256) external;

    function want(address) external view returns (address);

    function rewards() external view returns (address);

    function vaults(address) external view returns (address);

    function strategies(address) external view returns (address);
}

//
interface Uni {
    function swapExactTokensForTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}

interface UniPair {
    function token0() external view returns (address);
    function token1() external view returns (address);
}
struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt.
        uint256 multLpRewardDebt; //multLp Reward debt.
    }

struct PoolInfo {
    address lpToken;           // Address of LP token contract.
    uint256 allocPoint;       // How many allocation points assigned to this pool. MDXs to distribute per block.
    uint256 lastRewardBlock;  // Last block number that MDXs distribution occurs.
    uint256 accMdxPerShare; // Accumulated MDXs per share, times 1e12.
    uint256 accMultLpPerShare; //Accumulated multLp per share
    uint256 totalAmount;    // Total amount of current pool deposit.
}

interface IPool {
    function deposit(uint256 _pid, uint256 _amount) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
    function emergencyWithdraw(uint256 _pid) external;
    function userInfo(uint pid, address user) external view returns (UserInfo memory);
    function poolInfo(uint pid) external view returns (PoolInfo memory);
}

contract StrategyMdexLp {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address public constant usdt = 0xa71EdC38d189767582C38A3145b5873052c3e47a;
    address public constant husd = 0x0298c2b32eaE4da002a15f36fdf7615BEa3DA047;
    address public constant uniRouter =
        0xED7d5F38C79115ca12fe6C0041abb22F0A06C300;

    uint256 public strategistReward = 1000;
    uint256 public withdrawalFee = 0;
    uint256 public constant FEE_DENOMINATOR = 10000;

    IPool public pool = IPool(0xFB03e11D93632D97a8981158A632Dd5986F5E909);
    uint public poolId;

    address public RewardToken = 0x25D2e80cB6B86881Fd7e07dd263Fb79f4AbE033c; 

    address public want;

    address public governance;
    address public controller;
    address public strategist;

    address[] public path0;
    address[] public path1;

    address public token0;
    address public token1;

    constructor(
        address _controller,
        address _want,
        uint _pid,
        address[] memory _path0,
        address[] memory _path1
    ) {
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
        want = _want;
        poolId = _pid;
        path0 = _path0;
        path1 = _path1;

        if (_path0.length == 0) {
            token0 = RewardToken;
        } else {
            require(_path0[0] == RewardToken);
            token0 = _path0[_path0.length - 1];
        }
        if (_path1.length == 0) {
            token1 = RewardToken;
        } else {
            require(_path1[0] == RewardToken);
            token1 = _path1[_path1.length - 1];
        } 
        require(UniPair(_want).token0() == token0 || UniPair(_want).token0() == token1);
        require(UniPair(_want).token1() == token0 || UniPair(_want).token1() == token1);

        require(pool.poolInfo(_pid).lpToken == want);
    }

    function setStrategist(address _strategist) external {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!authorized"
        );
        strategist = _strategist;
    }

    function setWithdrawalFee(uint256 _withdrawalFee) external {
        require(msg.sender == governance, "!governance");
        withdrawalFee = _withdrawalFee;
    }

    function setStrategistReward(uint256 _strategistReward) external {
        require(msg.sender == governance, "!governance");
        strategistReward = _strategistReward;
    }

    function e_exit() external {
        require(msg.sender == governance, "!governance");
        pool.emergencyWithdraw(poolId);
        uint balance = IERC20(want).balanceOf(address(this));
        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_vault, balance);
    }

    function deposit() public {
        uint256 _want = IERC20(want).balanceOf(address(this));
        if (_want > 0) {
            IERC20(want).safeApprove(address(pool), 0);
            IERC20(want).safeApprove(address(pool), _want);
            IPool(pool).deposit(poolId, IERC20(want).balanceOf(address(this)));
        }
    }

    function withdraw(IERC20 _asset) external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        require(want != address(_asset), "want");
        require(RewardToken != address(_asset), "want");
        balance = _asset.balanceOf(address(this));
        if (balance > 0) {
            _asset.safeTransfer(controller, balance);
        }
    }

    function withdraw(uint256 _amount) external {
        require(msg.sender == controller, "!controller");
        uint256 _balance = IERC20(want).balanceOf(address(this));
        if (_balance < _amount) {
            _amount = _withdrawSome(_amount.sub(_balance));
            _amount = _amount.add(_balance);
        }

        uint256 _fee = _amount.mul(withdrawalFee).div(FEE_DENOMINATOR);

        if (_fee > 0) {
            IERC20(want).safeTransfer(IController(controller).rewards(), _fee);
        }
        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        if (_amount > _fee) {
            IERC20(want).safeTransfer(_vault, _amount.sub(_fee));
        }
    }

    function _withdrawSome(uint256 _amount) internal returns (uint256) {
        uint256 before = IERC20(want).balanceOf(address(this));
        if (_amount > 0) {
            pool.withdraw(poolId, _amount);
        }
        return IERC20(want).balanceOf(address(this)).sub(before);
    }

    // Withdraw all funds, normally used when migrating strategies
    function withdrawAll() external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        _withdrawAll();

        balance = IERC20(want).balanceOf(address(this));

        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        if (balance > 0) {
            IERC20(want).safeTransfer(_vault, balance);
        }
    }

    function _withdrawAll() internal {
        _withdrawSome(balanceOfPool());
    }

    modifier onlyBenevolent {
        require(
            msg.sender == tx.origin ||
                msg.sender == governance ||
                msg.sender == strategist
        );
        _;
    }

    function harvest() public onlyBenevolent {
        IPool(pool).deposit(poolId, 0);
        uint256 rewardAmt = IERC20(RewardToken).balanceOf(address(this));
        if (rewardAmt == 0) {
            return;
        }
        uint256 fee = rewardAmt.mul(strategistReward).div(FEE_DENOMINATOR);

        IERC20(RewardToken).safeTransfer(
            IController(controller).rewards(),
            fee
        );

        rewardAmt = IERC20(RewardToken).balanceOf(address(this));

        if (rewardAmt == 0) {
            return;
        }

        IERC20(RewardToken).safeApprove(uniRouter, 0);
        IERC20(RewardToken).safeApprove(uniRouter, uint256(-1));

        IERC20(token0).safeApprove(uniRouter, 0);
        IERC20(token0).safeApprove(uniRouter, uint256(-1));

        IERC20(token1).safeApprove(uniRouter, 0);
        IERC20(token1).safeApprove(uniRouter, uint256(-1));

        if (token0 != RewardToken) {
            Uni(uniRouter).swapExactTokensForTokens(
                rewardAmt.div(2),
                uint256(0),
                path0,
                address(this),
                block.timestamp.add(1800)
            );
        }
        if (token1 != RewardToken) {
            Uni(uniRouter).swapExactTokensForTokens(
                rewardAmt.div(2),
                uint256(0),
                path1,
                address(this),
                block.timestamp.add(1800)
            );
        }

        Uni(uniRouter).addLiquidity(
            token0,
            token1,
            IERC20(token0).balanceOf(address(this)),
            IERC20(token1).balanceOf(address(this)),
            0,
            0,
            address(this),
            block.timestamp.add(1800)
        );
        deposit();
    }

    function balanceOfWant() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }

    function balanceOfPool() public view returns (uint256) {
        UserInfo memory info = pool.userInfo(poolId, address(this));
        return info.amount;
    }

    function balanceOf() public view returns (uint256) {
        return balanceOfWant().add(balanceOfPool());
    }

    function setGovernance(address _governance) external {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setController(address _controller) external {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}
