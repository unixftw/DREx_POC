# import imp
# from brownie import AdvancedCollectible, accounts, config
# from scripts.helpful_script import get_breed, fund_advanced_collectible
# import time

# STATIC_SEED = 123


# def main():
#     dev = accounts.add(config["wallets"]["from_key"])
#     advaced_collectible = AdvancedCollectible[len(AdvancedCollectible) - 1]
#     # fund_advanced_collectible(advaced_collectible.address)
#     transaction = advaced_collectible.createCollectible(
#         "None", {"from": dev, "gas_limit": 1000000, "allow_revert": True}
#     )
#     transaction.wait(1)
#     time.sleep(55)
#     requestId = transaction.events["requestCollectible"]["requestId"]
#     token_id = advaced_collectible.requestIdToTokenId(requestId)
#     breed = get_breed(advaced_collectible.tokenToBreed(token_id))
#     print("Dog breed of tokenId {} is {}".format(token_id, breed))


from brownie import AdvancedCollectible, accounts, config
from scripts.helpful_script import get_breed, fund_advanced_collectible
import time


def main():
    for i in range(3):
        creating_collectibe()


def creating_collectibe():
    dev = accounts.add(config["wallets"]["from_key"])
    print(dev)
    advanced_collectible = AdvancedCollectible[
        len(AdvancedCollectible) - 1
    ]  # most recent deployment
    fund_advanced_collectible(advanced_collectible.address)
    print("sending link done")
    transaction = advanced_collectible.createCollectible("None", {"from": dev})
    print("Waiting on second transaction...")
    # wait for the 2nd transaction
    transaction.wait(10)
    time.sleep(55)
    requestId = transaction.events["RequestedCollectible"]["requestId"]
    token_id = advanced_collectible.requestIdToTokenId(requestId)
    breed = get_breed(advanced_collectible.tokenIdToBreed(token_id))
    number_of_advanced_collectibles = advanced_collectible.tokenCounter()
    print("NO of tokens created are {}".format(number_of_advanced_collectibles))
    print("DREX no  of tokenId {} is {}".format(token_id, breed))
