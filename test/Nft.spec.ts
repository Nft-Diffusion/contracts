import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { AiUp } from '../typechain-types/index';

describe("NFT_CONTRACT", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployNftContract() {
        // Contracts are deployed using the first signer/account by default
        const [owner, bob] = await ethers.getSigners();
        const NFT = await ethers.getContractFactory("AiUp");
        const Nft = await NFT.deploy();
        await Nft.deployed();
        const nft = Nft as AiUp;
        return { nft, owner, bob };
    }

    describe("Deployment", function () {
        it("Deploy and Mint", async function () {
            const { nft } = await loadFixture(deployNftContract);
            await nft.mintToken();
            const totalSupply = await nft.totalSupply();
            expect(totalSupply.toString()).to.equal('1');
        });
    });

    describe("Uploading NFT", function () {
        it("Set and Get TOKEN URI", async function () {
            const { nft } = await loadFixture(deployNftContract);
            await nft.mintToken();
            await nft.setTokenURI(0, 'PATH');
            const tokenURI = await nft.tokenURI('0');
            try {
                await nft.setTokenURI(0, 'PATH2');
            } catch (e: any) {
                expect(e.toString()).to.include('NFT Metadata already set!')
            }
            expect(tokenURI).to.be.equal("PATH");
        });
        it("Testing Set TokenURI", async () => {
            const { nft, bob } = await loadFixture(deployNftContract);
            await nft.connect(bob).mintToken();
            try { await nft.connect(bob).setTokenURI(0, 'Data') } // Ensure non-owner can't set Token URIs 
            catch (e: any) {
                expect(e.toString()).to.include('Ownable: caller is not the owner');
            }
            const tokenURI = await nft.tokenURI(0);
            expect(tokenURI.toString()).to.equal(''); 
        })
    });
});