//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token { 
    string public name;
    string public symbol;
    uint256 public decimals = 18;
    uint256 public totalSupply;

    // tracks balances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(
            address indexed from, 
            address indexed to, 
            uint256 value
    );

    event Approval(
            address indexed owner,
            address indexed spender,
            uint256 value
    );

    constructor(
            string memory _name, 
            string memory _symbol, 
            uint256 _totalSupply) 
    {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * (10 ** decimals);
        balanceOf[msg.sender] = totalSupply;   // sends tokens
    }

    function transfer(
            address _to, 
            uint256 _value) 
        public returns (bool success) 
    {
        // Check if sender has enough tokens
        require(balanceOf[msg.sender] >= _value);
        // Check if receiver is valid and tokens are not burned using ineternal function
        _transfer(msg.sender, _to, _value);
        // Emit transfer event
        emit Transfer(msg.sender, _to, _value);
        // Return success
        return true;
    }

    function _transfer(
            address _from, 
            address _to, 
            uint256 _value
    ) internal {
        // Check if receiver is valid and tokens are not burned
        require(_to != address(0));
        // Deduct tokens from spender 
        balanceOf[_from] = balanceOf[_from] - _value;
        // Credit tokens to receiver
        balanceOf[_to] = balanceOf[_to] + _value;
        // Emit transfer event
        emit Transfer(_from, _to, _value);
    }
    

    function approve(
            address _spender, 
            uint256 _value
    ) public returns (bool success
    ) {
        // Check if receiver is valid and tokens are not burned
        require(_spender != address(0));

        // Access the nested mapping
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
            address _from, 
            address _to, 
            uint256 _value
    ) public returns (bool success) 
    {
        // check approval
        require (_value <= balanceOf[_from]);
        require (_value <= allowance[_from][msg.sender]);

        // reset allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;

        // spend tokens
        _transfer(_from, _to, _value);
        
        return true;
    }
}
