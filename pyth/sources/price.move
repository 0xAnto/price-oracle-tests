module anto::example {
    use pyth::pyth;
    use pyth::price::Price;
    use pyth::price_identifier;
    use aptos_framework::coin;
    use aptos_framework::event;

    #[event]
    struct PriceUpdate has store, drop {
        price: Price,
    }

    public entry fun get_price(user: &signer, pyth_update_data: vector<vector<u8>>, price_identifier: vector<u8>) {

        let coins = coin::withdraw(user, pyth::get_update_fee(&pyth_update_data));
        pyth::update_price_feeds(pyth_update_data, coins);

        // Price Feed Identifier of BTC/USD in Testnet
        // let btc_price_identifier = x"f9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b";
        let btc_price_identifier = price_identifier;
        // Now we can use the prices which we have just updated
        let btc_usd_price_id = price_identifier::from_byte_vec(btc_price_identifier);
        let btc_price =  PriceUpdate { price: pyth::get_price(btc_usd_price_id) };
        event::emit<PriceUpdate>(btc_price)

    }

    public entry fun get_btc_price(user: &signer, pyth_update_data: vector<vector<u8>>) {

        let coins = coin::withdraw(user, pyth::get_update_fee(&pyth_update_data));
        pyth::update_price_feeds(pyth_update_data, coins);

        // Price Feed Identifier of BTC/USD in Testnet
        let btc_price_identifier = x"f9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b";
        // Now we can use the prices which we have just updated
        let btc_usd_price_id = price_identifier::from_byte_vec(btc_price_identifier);
        let btc_price =  PriceUpdate { price: pyth::get_price(btc_usd_price_id) };
        event::emit<PriceUpdate>(btc_price)

    }
}