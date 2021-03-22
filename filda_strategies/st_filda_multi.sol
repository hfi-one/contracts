pragma solidity ^0.7.3;
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
        bytes32 codehash;
        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function toPayable(address account)
        internal
        pure
        returns (address payable)
    {
        return address(uint160(account));
    }
}

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
}

interface CToken {
    function totalSupply() external view returns (uint256);

    function totalBorrows() external returns (uint256);

    function borrowIndex() external returns (uint256);

    function repayBorrow(uint256 repayAmount) external returns (uint256);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function mint(uint256 mintAmount) external returns (uint256);

    function underlying() external view returns (address);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function getAccountSnapshot(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        );

    function borrowRatePerBlock() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function borrowBalanceStored(address account)
        external
        view
        returns (uint256);

    function exchangeRateCurrent() external returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function getCash() external view returns (uint256);

    function accrueInterest() external returns (uint256);

    function seize(
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);
}

interface CETH {
    function mint() external payable;

    function redeem(uint256 redeemTokens) external returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function repayBorrow() external payable;

    function repayBorrowBehalf(address borrower) external payable;

    function liquidateBorrow(address borrower, address cTokenCollateral)
        external
        payable;
}

interface IUnitroller {
    function compAccrued(address) external view returns (uint256);

    function compSupplierIndex(address, address)
        external
        view
        returns (uint256);

    function compBorrowerIndex(address, address)
        external
        view
        returns (uint256);

    function compSpeeds(address) external view returns (uint256);

    function compBorrowState(address) external view returns (uint224, uint32);

    function compSupplyState(address) external view returns (uint224, uint32);

    /*** Assets You Are In ***/

    function enterMarkets(address[] calldata cTokens)
        external
        returns (uint256[] memory);

    function exitMarket(address cToken) external returns (uint256);

    /*** Policy Hooks ***/

    function mintAllowed(
        address cToken,
        address minter,
        uint256 mintAmount
    ) external returns (uint256);

    function mintVerify(
        address cToken,
        address minter,
        uint256 mintAmount,
        uint256 mintTokens
    ) external;

    function redeemAllowed(
        address cToken,
        address redeemer,
        uint256 redeemTokens
    ) external returns (uint256);

    function redeemVerify(
        address cToken,
        address redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    ) external;

    function borrowAllowed(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external returns (uint256);

    function borrowVerify(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external;

    function repayBorrowAllowed(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function repayBorrowVerify(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 borrowerIndex
    ) external;

    function liquidateBorrowAllowed(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount,
        uint256 seizeTokens
    ) external;

    function seizeAllowed(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeVerify(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external returns (uint256);

    function transferVerify(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external;

    /*** Liquidity/Liquidation Calculations ***/

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint256 repayAmount
    ) external view returns (uint256, uint256);

    // Claim all the COMP accrued by holder in all markets
    function claimComp(address holder) external;

    // Claim all the COMP accrued by holder in specific markets
    function claimComp(address holder, address[] calldata cTokens) external;

    // Claim all the COMP accrued by specific holders in specific markets for their supplies and/or borrows
    function claimComp(
        address[] calldata holders,
        address[] calldata cTokens,
        bool borrowers,
        bool suppliers
    ) external;

    function markets(address cTokenAddress)
        external
        view
        returns (bool, uint256);
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256 amt) external;
}

contract StrategyLendMulti {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    // Require a 0.1 buffer between
    // market collateral factor and strategy's collateral factor
    // when leveraging
    uint256 colFactorLeverageBuffer = 150;
    uint256 colFactorLeverageBufferMax = 1000;

    // Allow a 0.05 buffer
    // between market collateral factor and strategy's collateral factor
    // until we have to deleverage
    // This is so we can hit max leverage and keep accruing interest
    uint256 colFactorSyncBuffer = 100;
    uint256 colFactorSyncBufferMax = 1000;

    address public constant WHT = 0x5545153CCFcA01fbd7Dd11C0b23ba694D9509A6F;

    address public constant usdt = 0xa71EdC38d189767582C38A3145b5873052c3e47a;
    address public constant husd = 0x0298c2b32eaE4da002a15f36fdf7615BEa3DA047;
    address public constant uniRouter =
        0xED7d5F38C79115ca12fe6C0041abb22F0A06C300;

    uint256 public strategistReward = 1500;
    uint256 public withdrawalFee = 0;
    uint256 public constant FEE_DENOMINATOR = 10000;

    address public constant comptrl =
        0xb74633f2022452f377403B638167b0A135DB096d;
    address public comp = 0xE36FFD17B2661EB57144cEaEf942D95295E637F0;

    address public ctoken;
    address public want;

    address public governance;
    address public controller;
    address public strategist;

    mapping(address => bool) public farmers;

    constructor(
        address _controller,
        address _ctoken,
        address _want
    ) {
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
        ctoken = _ctoken;
        want = _want;
        require(CToken(ctoken).underlying() == want, "mismatch");
    }

    function addFarmer(address f) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!authorized"
        );
        farmers[f] = true;
    }

    function removeFarmer(address f) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!authorized"
        );
        farmers[f] = false;
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

    function getSuppliedView() public view returns (uint256) {
        (, uint256 cTokenBal, , uint256 exchangeRate) =
            CToken(ctoken).getAccountSnapshot(address(this));

        return cTokenBal.mul(exchangeRate).div(1e18);
    }

    function getBorrowedView() public view returns (uint256) {
        return CToken(ctoken).borrowBalanceStored(address(this));
    }

    function balanceOfPool() public view returns (uint256) {
        uint256 supplied = getSuppliedView();
        uint256 borrowed = getBorrowedView();
        uint b = supplied.sub(borrowed);
        return b;
    }

    function balanceOfWant() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }

    function balanceOf() public view returns (uint256) {
        return balanceOfWant().add(balanceOfPool());
    }

    // Given an unleveraged supply balance, return the target
    // leveraged supply balance which is still within the safety buffer
    function getLeveragedSupplyTarget(uint256 supplyBalance)
        public
        view
        returns (uint256)
    {
        uint256 leverage = getMaxLeverage();
        return supplyBalance.mul(leverage).div(1e18);
    }

    function getSafeLeverageColFactor() public view returns (uint256) {
        uint256 colFactor = getMarketColFactor();

        // Collateral factor within the buffer
        uint256 safeColFactor =
            colFactor.sub(
                colFactorLeverageBuffer.mul(1e18).div(
                    colFactorLeverageBufferMax
                )
            );

        return safeColFactor;
    }

    function getSafeSyncColFactor() public view returns (uint256) {
        uint256 colFactor = getMarketColFactor();

        // Collateral factor within the buffer
        uint256 safeColFactor =
            colFactor.sub(
                colFactorSyncBuffer.mul(1e18).div(colFactorSyncBufferMax)
            );

        return safeColFactor;
    }

    function getMarketColFactor() public view returns (uint256) {
        (, uint256 colFactor) = IUnitroller(comptrl).markets(ctoken);

        return colFactor;
    }

    // Max leverage we can go up to, w.r.t safe buffer
    function getMaxLeverage() public view returns (uint256) {
        uint256 safeLeverageColFactor = getSafeLeverageColFactor();

        // Infinite geometric series
        uint256 leverage = uint256(1e36).div(1e18 - safeLeverageColFactor);
        return leverage;
    }

    // If we have a strategy position at this SOS borrow rate and left unmonitored for 24+ hours, we might get liquidated
    // To safeguard with enough buffer, we divide the borrow rate by 2 which indicates allowing 48 hours response time
    function getSOSBorrowRate() public view returns (uint256) {
        uint256 safeColFactor = getSafeLeverageColFactor();
        return
            (
                colFactorLeverageBuffer.mul(182).mul(1e20).div(
                    colFactorLeverageBufferMax
                )
            )
                .div(safeColFactor);
    }

    function getColFactor() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return borrowed.mul(1e18).div(supplied);
    }

    function getSuppliedUnleveraged() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return supplied.sub(borrowed);
    }

    function getSupplied() public returns (uint256) {
        return CToken(ctoken).balanceOfUnderlying(address(this));
    }

    function getBorrowed() public returns (uint256) {
        return CToken(ctoken).borrowBalanceCurrent(address(this));
    }

    function getBorrowable() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        (, uint256 colFactor) = IUnitroller(comptrl).markets(ctoken);

        // 99.99% just in case some dust accumulates
        return
            supplied.mul(colFactor).div(1e18).sub(borrowed).mul(9990).div(
                10000
            );
    }

    function getCurrentLeverage() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return supplied.mul(1e18).div(supplied.sub(borrowed));
    }

    function setColFactorLeverageBuffer(uint256 _colFactorLeverageBuffer)
        public
    {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        colFactorLeverageBuffer = _colFactorLeverageBuffer;
    }

    function setColFactorSyncBuffer(uint256 _colFactorSyncBuffer) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        colFactorSyncBuffer = _colFactorSyncBuffer;
    }

    function sync() public returns (bool) {
        uint256 colFactor = getColFactor();
        uint256 safeSyncColFactor = getSafeSyncColFactor();

        // If we're not safe
        if (colFactor > safeSyncColFactor) {
            uint256 unleveragedSupply = getSuppliedUnleveraged();
            uint256 idealSupply = getLeveragedSupplyTarget(unleveragedSupply);

            deleverageUntil(idealSupply);

            return true;
        } else {
            leverageToMax();
            return true;
        }
    }

    function leverageToMax() public {
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        uint256 idealSupply = getLeveragedSupplyTarget(unleveragedSupply);
        leverageUntil(idealSupply);
    }

    // Leverages until we're supplying <x> amount
    // 1. Redeem <x> USDC
    // 2. Repay <x> USDC
    function leverageUntil(uint256 _supplyAmount) public {
        require(
            msg.sender == governance || msg.sender == controller,
            "!governance | controller"
        );
        // 1. Borrow out <X> USDC
        // 2. Supply <X> USDC

        uint256 leverage = getMaxLeverage();
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        require(
            _supplyAmount >= unleveragedSupply &&
                _supplyAmount <= unleveragedSupply.mul(leverage).div(1e18),
            "!leverage"
        );

        // Since we're only leveraging one asset
        // Supplied = borrowed
        uint256 _borrowAndSupply;
        uint256 supplied = getSupplied();
        while (supplied < _supplyAmount) {
            _borrowAndSupply = getBorrowable();

            if (supplied.add(_borrowAndSupply) > _supplyAmount) {
                _borrowAndSupply = _supplyAmount.sub(supplied);
            }

            CToken(ctoken).borrow(_borrowAndSupply);
            _deposit();

            supplied = supplied.add(_borrowAndSupply);
        }
    }

    function deleverageToMin() public {
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        deleverageUntil(unleveragedSupply);
    }

    // Deleverages until we're supplying <x> amount
    // 1. Redeem <x> USDC
    // 2. Repay <x> USDC
    function deleverageUntil(uint256 _supplyAmount) public {
        require(
            msg.sender == governance || msg.sender == controller,
            "!governance | controller"
        );
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        uint256 supplied = getSupplied();
        require(
            _supplyAmount >= unleveragedSupply && _supplyAmount <= supplied,
            "!deleverage"
        );

        // Since we're only leveraging on 1 asset
        // redeemable = borrowable
        uint256 _redeemAndRepay = getBorrowable();
        IERC20(want).safeApprove(ctoken, 0);
        IERC20(want).safeApprove(ctoken, uint256(-1));
        do {
            if (supplied.sub(_redeemAndRepay) < _supplyAmount) {
                _redeemAndRepay = supplied.sub(_supplyAmount);
            }

            require(
                CToken(ctoken).redeemUnderlying(_redeemAndRepay) == 0,
                "!redeem"
            );
            require(CToken(ctoken).repayBorrow(_redeemAndRepay) == 0, "!repay");

            supplied = supplied.sub(_redeemAndRepay);
        } while (supplied > _supplyAmount);
    }

    modifier onlyBenevolent {
        require(
            farmers[msg.sender] ||
                msg.sender == governance ||
                msg.sender == strategist
        );
        _;
    }

    function harvest() public onlyBenevolent {
        address[] memory markets = new address[](1);
        markets[0] = ctoken;
        IUnitroller(comptrl).claimComp(address(this), markets);
        uint256 _comp = IERC20(comp).balanceOf(address(this));

        uint256 before = IERC20(want).balanceOf(address(this));

        if (_comp > 0) {
            IERC20(comp).safeApprove(uniRouter, 0);
            IERC20(comp).safeApprove(uniRouter, uint256(-1));

            address[] memory path = new address[](2);
            path[0] = comp;
            path[1] = husd;
            Uni(uniRouter).swapExactTokensForTokens(
                _comp,
                uint256(0),
                path,
                address(this),
                block.timestamp.add(1800)
            );
            if (want != husd) {
                IERC20(husd).safeApprove(uniRouter, 0);
                IERC20(husd).safeApprove(uniRouter, uint256(-1));
                path[0] = husd;
                path[1] = usdt;
                Uni(uniRouter).swapExactTokensForTokens(
                    IERC20(husd).balanceOf(address(this)),
                    uint256(0),
                    path,
                    address(this),
                    block.timestamp.add(1800)
                );
                if (want != usdt && IERC20(usdt).balanceOf(address(this)) > 0) {
                    IERC20(usdt).safeApprove(uniRouter, 0);
                    IERC20(usdt).safeApprove(uniRouter, uint256(-1));
                    path[0] = usdt;
                    path[1] = want;
                    Uni(uniRouter).swapExactTokensForTokens(
                        IERC20(usdt).balanceOf(address(this)),
                        uint256(0),
                        path,
                        address(this),
                        block.timestamp.add(1800)
                    );
                }
            }
        }
        uint256 gain = IERC20(want).balanceOf(address(this)).sub(before);
        if (gain > 0) {
            uint256 _reward = gain.mul(strategistReward).div(FEE_DENOMINATOR);
            IERC20(want).safeTransfer(governance, _reward);
            _deposit();
        }
    }

    function deposit() public {
        if (_deposit() > 0) {
            sync();
        }
    }

    function _deposit() internal returns (uint) {
        uint256 _want = IERC20(want).balanceOf(address(this));
        if (_want > 0) {
            IERC20(want).safeApprove(ctoken, 0);
            IERC20(want).safeApprove(ctoken, _want);
            require(CToken(ctoken).mint(_want) == 0, "!deposit");
        }
        return _want;
    }

    function _withdrawSome(uint256 _amount) internal returns (uint256) {
        // -- CoinFabrik: save initial balance --
        uint256 _balance = balanceOfWant();
        uint256 _redeem = _amount;

        // Make sure market can cover liquidity
        require(CToken(ctoken).getCash() >= _redeem, "!cash-liquidity");

        // How much borrowed amount do we need to free?
        uint256 borrowed = getBorrowed();
        uint256 supplied = getSupplied();
        if (_redeem > supplied.sub(borrowed)) {
            _redeem = supplied.sub(borrowed);
        }
        uint256 curLeverage = getCurrentLeverage();
        uint256 borrowedToBeFree = _redeem.mul(curLeverage).div(1e18);

        // If the amount we need to free is > borrowed
        // Just free up all the borrowed amount
        if (borrowedToBeFree > borrowed) {
            deleverageToMin();
        } else {
            // Otherwise just keep freeing up borrowed amounts until
            // we hit a safe number to redeem our underlying
            deleverageUntil(supplied.sub(borrowedToBeFree));
        }

        // Redeems underlying
        if (_redeem > 0) {
            require(CToken(ctoken).redeemUnderlying(_redeem) == 0, "!redeem");
        }

        // -- CoinFabrik: calculate tokens redeemed --
        uint256 _reedemed = balanceOfWant();
        _reedemed = _reedemed.sub(_balance);

        return _reedemed;
    }

    function withdrawAll() external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        _withdrawAll();

        balance = IERC20(want).balanceOf(address(this));

        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_vault, balance);
    }

    function _withdrawAll() internal {
        uint256 borrowed = getBorrowed();
        uint256 supplied = getSupplied();
        _withdrawSome(supplied.sub(borrowed));
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
        IERC20(want).safeTransfer(_vault, _amount.sub(_fee));
    }

    function withdraw(IERC20 _asset) external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        require(want != address(_asset), "want");
        require(ctoken != address(_asset), "want");
        require(comp != address(_asset), "want");
        balance = _asset.balanceOf(address(this));
        _asset.safeTransfer(controller, balance);
    }


    // emergency functions
    function e_exit() public {
        require(msg.sender == governance, "!governance");
        deleverageToMin();
        uint amt = CToken(ctoken).balanceOf(address(this));
        if (amt > 0) {
            require(CToken(ctoken).redeem(amt) == 0, "!e_redeem");
        }
        
        uint balance = IERC20(want).balanceOf(address(this));
        if (balance > 0) {
            address _vault = IController(controller).vaults(address(want));
            require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
            IERC20(want).safeTransfer(_vault, balance);
        }
    }
    function e_redeem(uint amount) public {
        require(msg.sender == governance, "!governance");
        require(CToken(ctoken).redeemUnderlying(amount) == 0, "!e_redeem");
    }

    function e_redeemAll() public {
        require(msg.sender == governance, "!governance");
        uint amt = CToken(ctoken).balanceOfUnderlying(address(this));
        require(CToken(ctoken).redeemUnderlying(amt) == 0, "!e_redeem");
    }

    function e_redeemCToken(uint amount) public {
        require(msg.sender == governance, "!governance");
        require(CToken(ctoken).redeem(amount) == 0, "!e_redeem");
    }

    function e_redeemAllCToken() public {
        require(msg.sender == governance, "!governance");
        uint amt = CToken(ctoken).balanceOf(address(this));
        require(CToken(ctoken).redeem(amt) == 0, "!e_redeem");
    }

    function e_repayAll() public {
        require(msg.sender == governance, "!governance");
        IERC20(want).safeApprove(ctoken, 0);
        IERC20(want).safeApprove(ctoken, uint256(-1));
        uint borrowed = CToken(ctoken).borrowBalanceCurrent(address(this));
        uint bl = IERC20(want).balanceOf(address(this));
        if (bl > borrowed) {
            require(CToken(ctoken).repayBorrow(borrowed) == 0, "!repay");
        } else {
            require(CToken(ctoken).repayBorrow(bl) == 0, "!repay");
        }
    }

    function e_repay(uint amount) public {
        require(msg.sender == governance, "!governance");
        IERC20(want).safeApprove(ctoken, 0);
        IERC20(want).safeApprove(ctoken, uint256(-1));
        uint borrowed = CToken(ctoken).borrowBalanceCurrent(address(this));
        uint bl = IERC20(want).balanceOf(address(this));
        require(amount <= bl);
        if (amount > borrowed) {
            require(CToken(ctoken).repayBorrow(borrowed) == 0, "!repay");
        } else {
            require(CToken(ctoken).repayBorrow(amount) == 0, "!repay");
        }
    }

    function e_collect() public {
        require(msg.sender == governance, "!governance");
        uint balance = IERC20(want).balanceOf(address(this));

        address _vault = IController(controller).vaults(address(want));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_vault, balance);
    }

    function getDiv() public view returns (uint256) {
        uint256 supplied = getSuppliedView();
        uint256 borrowed = getBorrowedView();
        return borrowed.mul(10000).div(supplied);
    }

    receive() external payable {}
}
