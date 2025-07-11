use contracts::MintableToken::{
    IMintableTokenDispatcher, IMintableTokenDispatcherTrait
};

use openzeppelin_access::ownable::interface::{
    IOwnableDispatcher, IOwnableDispatcherTrait,
};

use snforge_std::{
    ContractClassTrait, declare, DeclareResultTrait,
};

use starknet::ContractAddress;

const INITIAL_SUPPLY: u256 = 100000;

fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}

fn USER1() -> ContractAddress {
    'USER1'.try_into().unwrap()
}

fn __deploy__(initial_supply: u256) -> (IMintableTokenDispatcher, IOwnableDispatcher) {
    let contract_class = declare("MintableToken").unwrap().contract_class();

    let mut calldata: Array<felt252> = array![];

    // For u256, you need to add its low and high parts separately
    // The U256 type itself has `low` and `high` fields
    calldata.append(initial_supply.low);
    calldata.append(initial_supply.high);

    
    initial_supply.serialize(ref calldata);
    OWNER().serialize(ref calldata);

    let (contract_address, _) = contract_class.deploy(@calldata).unwrap();

    let token = IMintableTokenDispatcher { contract_address };
    let ownable = IOwnableDispatcher { contract_address };

    (token, ownable)
}

fn __deploy__(initial_supply: u256) -> (IMintableTokenDispatcher, IOwnableDispatcher) {
    let contract_class = declare("MintableToken").unwrap().contract_class();

    let mut calldata: Array<felt252> = array![];

    // For u256, you need to add its low and high parts separately
    // The U256 type itself has `low` and `high` fields
    calldata.append(initial_supply.low);
    calldata.append(initial_supply.high);

    // For ContractAddress, it's just one felt252
    OWNER().serialize(ref calldata); // This is fine, as ContractAddress serializes to one felt252

    let (contract_address, _) = contract_class.deploy(@calldata).unwrap();

    let token = IMintableTokenDispatcher { contract_address };
    let ownable = IOwnableDispatcher { contract_address };

    (token, ownable)
}

#[test]
fn test_mintable_token_deploy() {
    let (token, ownable) = __deploy__(INITIAL_SUPPLY);

    let total = token.get_total_minted();
    assert(total == INITIAL_SUPPLY, 'initial supply mismatch');

    println!("I am runnning");
    let owner = ownable.owner();
    assert(owner == OWNER(), 'owner mismatch');
}
