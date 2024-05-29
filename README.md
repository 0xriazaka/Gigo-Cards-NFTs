# Gigo Cards SUI NFT Example

A pioneering example of SUI NFTs

## Publish

```bash
sui client publish --gas-budget 100000000 .
```

## Usage

```bash

# mint a gigocard NFT
sui client call --function mint_gigocard --module gigocard --package $PACKAGE_ID --args $MONSTER $ROLE $REGION $READY_TO_FIGHT --gas-budget 10000000

# transfer the NFT to another address
sui client call --function transfer_gigocard --module gigocard --package $PACKAGE_ID --args $GIGOCARD $RECIPIENT_ADDRESS --gas-budget 10000000

# set ready to fight
sui client call --function set_ready_to_fight --module gigocard --package $PACKAGE_ID --args $GIGOCARD $READY_TO_FIGHT_BOOL --gas-budget 10000000

# destroy the NFT
sui client call --function destroy --module gigocard --package $PACKAGE_ID --args $GIGOCARD --gas-budget 10000000

```
## Unit Testing

```bash
sui move test
```
![alt text](https://github.com/0xriazaka/Gigo-Cards-NFTs/blob/main/tests/test.png)

## Contributing

Pull requests are welcome. For major changes, please open an issue first
