
module gigocard::gigocard {
    use std::option:: {Self, Option};
    use std::string:: {Self, String};
    use sui::transfer;
    use sui::object:: {Self, UID, ID};
    use sui::tx_context:: {Self, TxContext};
    use sui::coin:: {Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    // errors
    const NOT_THE_OWNER: u64 = 0;

    // gigo monster card
    struct GigoCard has key, store {
        id: UID,
        owner: address,
        monster: String,
        role: String,
        region: String,
        ready_to_fight: bool,
    }

    // events
    struct GigoCardCreated has copy, drop {
        monster_id: ID,
        owner: address,
    }

    // mint gigo card
    public fun mint_gigocard (
        ctx: &mut TxContext,
        monster: vector<u8>,
        role: vector<u8>,
        region: vector<u8>,
        ready_to_fight: bool,    
    ) {
        let sender = tx_context::sender(ctx);
        let gigocard = GigoCard {
            id: object::new(ctx),
            owner: sender,
            monster: string::utf8(monster),
            role: string::utf8(role),
            region: string::utf8(region),
            ready_to_fight: true, 
        };

        event::emit(GigoCardCreated {
            monster_id: object::id(&gigocard),
            owner: sender,
        });

        transfer::public_transfer(gigocard, sender);
    }

    // transfer gigocard
    public fun transfer_gigocard (
        gigocard: GigoCard, 
        recipient: address, 
        _: &mut TxContext
    ) {
        transfer::public_transfer(gigocard, recipient)
    }

    // set ready_to_fight
    public fun ready_to_fight (
        gigocard: &mut GigoCard,
        ready_to_fight: bool
    ) {
        gigocard.ready_to_fight = ready_to_fight;
    }

    // delete gigo card

    public fun destroy (
        gigocard: GigoCard, 
        ctx: &mut TxContext
    ) {
        assert!(gigocard.owner == tx_context::sender(ctx), 0);
        let GigoCard { id, owner: _, monster: _, role: _, region: _, ready_to_fight: _ } = gigocard;
        object::delete(id)
    }
}

