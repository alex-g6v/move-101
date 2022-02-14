// Approach A: store a ledger of coin owners and modify it

module 0x3::CoinA {
    use Std::Signer;
    use Std::Vector;

    struct Holder has key, store { 
        account: address,
        balance: u64
    }
    struct Holders has key {
        items: vector<Holder>
    }

    const OWN_ADDRESS: address = @0x3;

    // Initialize holders
    public fun init(signer: &signer) {
        assert!(Signer::address_of(signer) == OWN_ADDRESS, 1);
        assert!(exists<Holders>(Signer::address_of(signer)) == false, 3);
        move_to<Holders>(signer, Holders { items: Vector::empty<Holder>() });
    }

    fun find_or_create_holder(account: address): u64 acquires Holders {
        assert!(exists<Holders>(OWN_ADDRESS), 3);
        let holders = &mut borrow_global_mut<Holders>(OWN_ADDRESS).items;
        let total = Vector::length(holders);
        let i = 0;
        while (i < total) {
            let holder = Vector::borrow(holders, i);
            if (holder.account == account) 
                break;
            i = i + 1;
        };
        // Not found? then create a holder with an empty balance
        if (i == total) {
            let new_holder = Holder { account, balance: 0 };
            Vector::push_back(holders, new_holder);
        };
        return i
    }

    public fun give_coins(signer: &signer, to_account: address, amount: u64) acquires Holders {
        assert!(Signer::address_of(signer) == OWN_ADDRESS, 1);
        // Update signer balance if all is fine
        let holder_at = find_or_create_holder(to_account);
        let holder_items = &mut borrow_global_mut<Holders>(OWN_ADDRESS).items;
        let holder_balance = &mut Vector::borrow_mut(holder_items, holder_at).balance;
        *holder_balance = *holder_balance + amount;
    }

    public fun send_to(signer: &signer, to_address: address, amount: u64) acquires Holders {
        assert!(exists<Holders>(OWN_ADDRESS), 3);

        // Ensure both holders exist
        let from_index = find_or_create_holder(Signer::address_of(signer));
        let to_index = find_or_create_holder(to_address);
        let holder_items = &mut borrow_global_mut<Holders>(OWN_ADDRESS).items;

        let from_balance = &mut Vector::borrow_mut(holder_items, from_index).balance;
        // Update both balances accordingly
        assert!(*from_balance > amount, 4);
        *from_balance = *from_balance - amount;
        let to_balance = &mut Vector::borrow_mut(holder_items, to_index).balance;
        *to_balance = *to_balance + amount;
    }
}
