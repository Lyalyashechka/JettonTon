import "@stdlib/deploy";
import "./messages";

contract Pool with Deployable {
    contractAddressForWithdraw: String;
    userMustEarnTokens: map<Address, Int>;
    jettonWalletAddress: Address;

    init() {
        self.contractAddressForWithdraw = "";
        self.userMustEarnTokens = emptyMap();
        self.jettonWalletAddress = sender();
    }
    
    receive(msg: Deposit) {
        self.userMustEarnTokens.set(sender(), msg.amount);
    }

    receive(msg: SetAddressJetton) {
        self.jettonWalletAddress = msg.address;
    }

    receive("claim") {
        let tokenClaim: Int? = self.userMustEarnTokens.get(sender());

        send(SendParameters{
            to: self.jettonWalletAddress,
            body: Transfer{amount: tokenClaim!!, to: sender()}.toCell(),
            value: ton("0.03"),
            mode: SendIgnoreErrors
        });
    }
}