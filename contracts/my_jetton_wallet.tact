import "@stdlib/deploy";
import "@stdlib/ownable";
import "./messages";

contract MyJettonWallet with Deployable, Ownable {

    parent: Address; //address jettonMaster
    owner: Address; //address client 
    balance: Int as coins;

    init(parent: Address, owner: Address) {
        self.parent = parent;
        self.owner = owner;
        self.balance = 0;
    }

    receive(msg: InternalAdd) {
        if (msg.origin == self.parent) {
            require(sender() == self.parent, "Parent only");
        } else {
            let init: StateInit = initOf MyJettonWallet(self.parent, msg.origin);
            require(sender() == contractAddress(init), "jettonWallet only");
        }

        self.balance = self.balance + msg.amount;
    }

    receive(msg: Transfer) {
        require(sender() == self.owner, "Access denied");
        require(self.balance >= msg.amount, "Insufficient balance");
        
        self.balance = self.balance - msg.amount;
        let init: StateInit = initOf MyJettonWallet(self.parent, msg.to);
        send(SendParameters{
            to: contractAddress(init),
            body: InternalAdd{amount: msg.amount, origin: self.owner}.toCell(),
            value: ton("0.03"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data
        });
    }

    get fun myBalance(): Int {
        return self.balance;
    }
}