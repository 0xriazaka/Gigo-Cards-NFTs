
#[test_only]
module test::test_gigocard {
    use sui::test_scenario;
    use gigocard::gigocard::{Self, GigoCard};

    // Users
    const USER1: address = @0xab;
    const USER2: address = @0xcd;

    // Test
    #[test]
    fun test_mint() {

        // Test Mint
        let mut scenario_val = test_scenario::begin(USER1);
        let scenario = &mut scenario_val;
        {
            let monster = b"Dragon".to_string();
            let role = b"Warrior".to_string();
            let region = b"Skylands".to_string();
            let ready_to_fight = true;
            // Create the gigocard and transfer it to the owner
            let gigocard = gigocard::mint_gigocard(test_scenario::ctx(scenario), monster, role, region, ready_to_fight);
            transfer::public_transfer(gigocard, USER1);
        };
          
        // Test Transaction
        test_scenario::next_tx(scenario, USER1);
        {
            let gigocard = test_scenario::take_from_sender<GigoCard>(scenario);

            gigocard::transfer_gigocard(gigocard, USER2, test_scenario::ctx(scenario));

            // Check that USER1 doesn't own the NFT
            assert!(!test_scenario::has_most_recent_for_sender<GigoCard>(scenario), 0);
        };
        test_scenario::next_tx(scenario, USER2);
        {   
            // Check that USER2 own the NFT
            assert!(test_scenario::has_most_recent_for_sender<GigoCard>(scenario), 0);
        }; 
        
        // Test Ready to Fight
        test_scenario::next_tx(scenario, USER2);
        {
            let mut gigocard = test_scenario::take_from_sender<GigoCard>(scenario);

            gigocard::set_ready_to_fight(&mut gigocard, true);

            // Check if its ready to fight
            assert!(gigocard.ready_to_fight() == true, 0);
            test_scenario::return_to_sender(scenario, gigocard);
        };

        // Test Destroy the NFT
        test_scenario::next_tx(scenario, USER2);
        {
            let gigocard = test_scenario::take_from_sender<GigoCard>(scenario);

            gigocard::destroy(gigocard, test_scenario::ctx(scenario));

            // Check that USER2 no more own the NFT
            assert!(!test_scenario::has_most_recent_for_sender<GigoCard>(scenario), 0);
        };
        test_scenario::end(scenario_val);
    }

}