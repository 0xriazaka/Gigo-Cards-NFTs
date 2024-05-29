
module gigocard::gigocard {
    use std::string::String;
    use sui::event;

    // gigo monster card
    public struct GigoCard has key, store {
        id: UID,
        monster: String,
        role: String,
        region: String,
        ready_to_fight: bool,
    }

    // events
    public struct GigoCardCreated has copy, drop {
        monster_id: ID,
        minted_by: address,
    }

    // mint gigo card
    public fun mint_gigocard (
        ctx: &mut TxContext,
        monster: String,
        role: String,
        region: String,
        _ready_to_fight: bool,    
    ): GigoCard {
        let sender = tx_context::sender(ctx);
        let gigocard = GigoCard {
            id: object::new(ctx),
            monster: monster,
            role: role,
            region: region,
            ready_to_fight: true, 
        };

        event::emit(GigoCardCreated {
            monster_id: object::id(&gigocard),
            minted_by: sender,
        });
        gigocard
    }

    // transfer gigocard
    public entry fun transfer_gigocard ( gigocard: GigoCard, recipient: address, _: &mut TxContext) {
        transfer::public_transfer(gigocard, recipient)
    }

    // set ready_to_fight
    public entry fun set_ready_to_fight (
        gigocard: &mut GigoCard,
        ready_to_fight: bool
    ) {
        gigocard.ready_to_fight = ready_to_fight;
    }

    // delete gigo card
    public entry fun destroy (
        gigocard: GigoCard, 
        _: &mut TxContext
    ) {
        let GigoCard { id, monster: _, role: _, region: _, ready_to_fight: _ } = gigocard;
        object::delete(id)
    }

    // helper functions
    public fun ready_to_fight(gigocard: &GigoCard) : bool {
        gigocard.ready_to_fight
    }
}

