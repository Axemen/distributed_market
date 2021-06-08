from web3 import Web3


class Market:

    def __init__(self, abi_path:str, binary_path:str, address:str):
        self.w3 = Web3()
        self.contract = self.w3.eth.contract(address, abi, binary)