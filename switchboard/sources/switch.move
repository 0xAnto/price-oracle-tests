module feed::switchboard {

use switchboard::aggregator;
use switchboard::math;
use std::signer::address_of;


// store latest value
struct AggregatorInfo has copy, drop, store, key {
  aggregator_addr: address,
  latest_result: u128,
  latest_result_scaling_factor: u8,
  latest_result_neg: bool,
}

// get latest value
public entry fun save_latest_value(account: &signer, aggregator_addr: address) acquires AggregatorInfo {
  // get latest value
  let latest_value = aggregator::latest_value(aggregator_addr);
  let (value, scaling_factor, neg) = math::unpack(latest_value);
  if(exists<AggregatorInfo>(address_of(account))) {
    let aggregator_info = borrow_global_mut<AggregatorInfo>(address_of(account));
    aggregator_info.latest_result = value;
    aggregator_info.latest_result_scaling_factor = scaling_factor;
    aggregator_info.latest_result_neg = neg;
  } else {
    move_to(account, AggregatorInfo {
      aggregator_addr: aggregator_addr,
      latest_result: value,
      latest_result_scaling_factor: scaling_factor,
      latest_result_neg: neg,
    });
  }
}

// some testing that uses aggregator test utility functions
#[test(account = @0x1)]
public entry fun test_aggregator(account: &signer) {

  // creates test aggregator with data
  aggregator::new_test(account, 100, 0, false);

  // print out value
  std::debug::print(&aggregator::latest_value(address_of(account)));
}
}