pragma solidity ^0.8.1;

/**
First Smart Contract
*/

// SPDX-License-Identifier: GPL-3.0

contract Contract01 {
    string public myString = "hello world";
}

/**
## Solidity Basics- Variables
*/

contract Contract02 {
    string public name;
    uint256 public age;
    address public paddress;

    function setDetail(string memory _name, uint256 _age)
        public
        returns (
            string memory,
            uint256,
            address
        )
    {
        name = _name;
        age = _age;
        paddress = msg.sender;
        return (name, age, paddress);
    }
}

/**
## **Overflow and Underflow:**
*/
// pragma solidity 0.7.0;

contract Contract03 {
    uint8 public myUint8;

    function decrement() public {
        myUint8--;
    }

    function increment() public {
        myUint8++;
    }
}

/**
## Error: **Overflow and Underflow:**
*/

// pragma solidity 0.8.0;

contract Contract04 {
    uint8 public myUint8;

    function decrement() public {
        myUint8--;
    }

    function increment() public {
        myUint8++;
    }
}

/**
## Unchecked: **Overflow and Underflow:**
*/

// pragma solidity 0.8.0;

contract Contract05 {
    uint8 public myUint8;

    function decrement() public {
        unchecked {
            myUint8--;
        }
    }

    function increment() public {
        unchecked {
            myUint8++;
        }
    }
}

/**
## Mapping and Structs
 */

contract Contract05_01 {
    struct Payment {
        uint256 amount;
        uint256 timestamp;
    }

    struct Balance {
        uint256 totalBalance;
        uint256 numPayments;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balanceReceived;

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/**
## Deposit and withdraw
*/

contract Contract06 {
    uint256 public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/**
## Deposit and withdraw
*/

contract Contract07 {
    uint256 public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**withdrawMoney**/
    function withdrawMoney() public {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
}

/**
 ## Withdraw to a account
 */

contract Contract08 {
    uint256 public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }

    function withdrawMoneyTo(address payable _to) public {
        _to.transfer(getBalance());
    }
}

/**
## Unsecure Smart Contract**
*/

contract Contract09 {
    function sendMoney() public payable {}

    function withdrawAllMoney(address payable _to) public {
        _to.transfer(address(this).balance);
    }
}

/**
## constructor and ownership**
*/

contract Contract10 {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney() public payable {}

    function withdrawAllMoney(address payable _to) public {
        require(owner == msg.sender, "You cannot withdraw.");
        _to.transfer(address(this).balance);
    }
}

/**
## Pause and destroy**
 */

contract Contract11 {
    address public owner;
    bool public paused;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney() public payable {}

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function withdrawAllMoney(address payable _to) public {
        require(owner == msg.sender, "You cannot withdraw.");
        require(paused == false, "Contract Paused");
        _to.transfer(address(this).balance);
    }

    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
}

/**
## Send Money
 */

contract Contract12 {
    struct Payment {
        uint256 amount;
        uint256 timestamp;
    }

    struct Balance {
        uint256 totalBalance;
        uint256 numPayments;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balanceReceived;

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
    new code
     */
    function sendMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;

        Payment memory payment = Payment(msg.value, block.timestamp);
        balanceReceived[msg.sender].payments[
            balanceReceived[msg.sender].numPayments
        ] = payment;
        balanceReceived[msg.sender].numPayments++;
    }
}

/**
## Withdraw Money
 */

contract Contract13 is Contract12 {
    function withdrawMoney(address payable _to, uint256 _amount) public {
        require(
            _amount <= balanceReceived[msg.sender].totalBalance,
            "not enough funds"
        );
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }

    function withdrawAllMoney(address payable _to) public {
        uint256 balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
}

/**
## Exception Handling
 */

contract Contract14 {
    mapping(address => uint256) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        if (_amount <= balanceReceived[msg.sender]) {
            balanceReceived[msg.sender] -= _amount;
            _to.transfer(_amount);
        }
    }
}

/**
## Add a Require
 */

contract Contract15 {
    mapping(address => uint256) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        // added required
        require(
            _amount <= balanceReceived[msg.sender],
            "Not Enough Funds, aborting"
        );

        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}

/**
## Add an Assert
 */

contract Contract16 {
    mapping(address => uint64) public balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint64(msg.value));
        balanceReceived[msg.sender] += uint64(msg.value);
        assert(balanceReceived[msg.sender] >= uint64(msg.value));
    }
}

/**
### Try/Catch
 */

contract Contract17WillThrow {
    function aFunction() public pure {
        require(false, "Error message");
    }
}

/**
### Try/Catch
 */
/* rest of the code*/
contract Contract17ErrorHandling {
    event ErrorLogging(string reason);

    function catchError() public {
        Contract17WillThrow will = new Contract17WillThrow();
        try will.aFunction() {
            //here we could do something if it works
        } catch Error(string memory reason) {
            emit ErrorLogging(reason);
        }
    }
}
