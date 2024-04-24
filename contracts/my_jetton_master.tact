import "@stdlib/deploy";
import "./my_jetton_wallet";
import "./messages";

struct Metadata{
    total_supply: Int;
    mintable: Bool;
    owner: Address;
    jetton_wallet_code: Cell;
}

contract MyJettonMaster with Deployable {
    total_supply: Int as coins = 0;
    mintable: Bool = true;
    owner: Address;
    //jetton_content: Cell;
    symbol: String;
    
    init() {
        self.owner = sender();
        //self.jetton_content = jetton_content;
        self.symbol = "SCAM_TOKEN";
        self.total_supply = ton("10000");
        self.mint(ton("100"), sender());    
    }

    receive("Mint") { // Public Minting
        let ctx: Context = context();
        require(self.mintable, "Can't Mint Anymore");
        self.mint(100, sender());
    }
    
    fun mint(amount: Int, to: Address) {
        let init: StateInit = initOf MyJettonWallet(myAddress(), to);
        send(SendParameters{
            to: contractAddress(init),
            body: InternalAdd{amount: amount, origin: myAddress()}.toCell(),
            value: ton("0.03"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data
        });
    }

    get fun walletAddress(owner: Address): Address{
        let init: StateInit = initOf MyJettonWallet(myAddress(), owner);
        return contractAddress(init);
    }

     get fun get_jetton_data(): Metadata {
        return Metadata{total_supply: self.total_supply, mintable: self.mintable, owner: self.owner, jetton_wallet_code: (initOf MyJettonWallet(self.owner, myAddress())).code};
    }
}
