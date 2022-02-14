// Approach B: store Coin resource on user's addresses

module 0x3::CoinB {
    use Std::Signer;
    //use Std::Debug;

    struct Coin has key { value: u64 }

    const OWN_ADDRESS: address = @0x3;

    // Signer can create it's wallet
    public fun create_coin_wallet(signer: &signer) {
        assert!(exists<Coin>(Signer::address_of(signer)) == false, 1);
        move_to<Coin>(signer, Coin { value: 0 });
    }


    public fun give_coins(signer: &signer, to_account: address, amount: u64) acquires Coin {
        assert!(Signer::address_of(signer) == OWN_ADDRESS, 2);
        let s_balance = &mut borrow_global_mut<Coin>(to_account).value;
        *s_balance = *s_balance + amount;
    }


    public fun send_to(signer: &signer, to_address: address, amount: u64) acquires Coin {
        // if only both have coin wallets
        assert!(exists<Coin>(Signer::address_of(signer)), 3);
        assert!(exists<Coin>(to_address), 4);
        let s_balance = &mut borrow_global_mut<Coin>(Signer::address_of(signer)).value;
        assert!(*s_balance >= amount, 5);
        *s_balance = *s_balance - amount;
        let t_balance = &mut borrow_global_mut<Coin>(to_address).value;
        *t_balance = *t_balance + amount;
    }
}
