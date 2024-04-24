import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano, Address } from '@ton/core';
import { MyJeton } from '../wrappers/MyJeton';
import { MyJettonMaster } from '../wrappers/MyJettonMaster';
import { MyJettonWallet } from '../wrappers/MyJettonWallet';
import '@ton/test-utils';
import "tonweb"
import TonWeb from 'tonweb';
import { Pool } from '../wrappers/Pool';

describe('MyJeton', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let myJettonMaster: SandboxContract<MyJettonMaster>;
    let myPool: SandboxContract<Pool>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        myJettonMaster = blockchain.openContract(await MyJettonMaster.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployRes = await myJettonMaster.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        myPool = blockchain.openContract(await Pool.fromInit());

        const deployResMyPool = await myPool.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

    });

    it('should deploy', async () => {
        const user1 = await blockchain.treasury('user');

        const userDepositInPool = await blockchain.treasury('user')

        myJettonMaster.send(
            user1.getSender(),
            {
                value: toNano('1'),
            },
            'Mint'
        );

        const addressJetton = await myJettonMaster.getWalletAddress(user1.address);

        const myJettonWallet = blockchain.openContract(await MyJettonWallet.fromAddress(addressJetton));
        const deployRes = await myJettonWallet.send(
            user1.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        console.log(await myJettonWallet.getMyBalance());

        myJettonWallet.send(
            user1.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Transfer',
                amount: BigInt(50),
                to: myPool.address
            }
        )

        const addressJettonPool = await myJettonMaster.getWalletAddress(myPool.address);
        const myJettonPoolWallet = blockchain.openContract(await MyJettonWallet.fromAddress(addressJettonPool));

        const deployRes1 = await myJettonPoolWallet.send(
            user1.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );
        console.log(await myJettonPoolWallet.getMyBalance());

        myPool.send(
            userDepositInPool.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deposit',
                amount: BigInt(15)
            }
        );

        myPool.send(
            user1.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'SetAddressJetton',
                address: addressJettonPool
            }
        );

        myPool.send(
            userDepositInPool.getSender(),
            {
                value: toNano('0.05'),
            },
            "claim"
        );

        const addressJettonuserDepositInPool = await myJettonMaster.getWalletAddress(userDepositInPool.address);
        const myJettonuserDepositInPoolWallet = blockchain.openContract(await MyJettonWallet.fromAddress(addressJettonuserDepositInPool));

        const deployRes2 = await myJettonuserDepositInPoolWallet.send(
            user1.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        console.log(await myJettonuserDepositInPoolWallet.getMyBalance());

    });
});
