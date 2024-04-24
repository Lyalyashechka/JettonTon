import { toNano } from '@ton/core';
import { MyJeton } from '../wrappers/MyJeton';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const myJeton = provider.open(await MyJeton.fromInit());

    await myJeton.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(myJeton.address);

    // run methods on `myJeton`
}
