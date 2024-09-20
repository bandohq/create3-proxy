// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "solmate/src/utils/CREATE3.sol";
import "../src/CREATE3UUPSProxy.sol";
import "./TestImplementation.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract CREATE3UUPSProxyTest is Test {
    function testDeployImplementation() public {
        bytes32 salt = keccak256("test_implementation");
        bytes memory creationCode = type(TestImplementation).creationCode;

        address impl = CREATE3UUPSProxy._deployImplementation(salt, creationCode);

        assertTrue(impl != address(0), "Implementation should be deployed");
        assertTrue(impl.code.length > 0, "Implementation should have code");
    }

    function testDeployProxy() public {
        bytes32 salt = keccak256("test_proxy");
        bytes memory creationCode = type(TestImplementation).creationCode;
        uint256 initialValue = 42;
        bytes memory initializerData = abi.encodeWithSignature("initialize(uint256)", initialValue);

        try CREATE3UUPSProxy.deploy(salt, creationCode, initializerData) returns (address proxy) {
            assertTrue(proxy != address(0), "Proxy should be deployed");
            assertTrue(proxy.code.length > 0, "Proxy should have code");

            TestImplementation impl = TestImplementation(proxy);
            assertEq(impl.value(), initialValue, "Proxy should be initialized with correct value");
        } catch Error(string memory reason) {
            fail(string(abi.encodePacked("Deployment failed: ", reason)));
        } catch (bytes memory lowLevelData) {
            fail(string(abi.encodePacked("Deployment failed with raw error: ", vm.toString(lowLevelData))));
        }
    }

    function testProxyFunctionality() public {
        bytes32 salt = keccak256("test_proxy_functionality");
        bytes memory creationCode = type(TestImplementation).creationCode;
        uint256 initialValue = 42;
        bytes memory initializerData = abi.encodeWithSignature("initialize(uint256)", initialValue);

        address proxy = CREATE3UUPSProxy.deploy(salt, creationCode, initializerData);
        TestImplementation impl = TestImplementation(proxy);

        uint256 newValue = 100;
        impl.setValue(newValue);
        assertEq(impl.value(), newValue, "Proxy should update value correctly");
    }

    function testDeterministicAddresses() public {
        bytes32 salt = keccak256("test_deterministic");
        bytes memory creationCode = type(TestImplementation).creationCode;
        bytes memory initializerData = abi.encodeWithSignature("initialize(uint256)", 42);
        address predictedProxy1 = CREATE3.getDeployed(salt);
        address proxy1 = CREATE3UUPSProxy.deploy(salt, creationCode, initializerData);
        assertEq(proxy1, predictedProxy1, "Proxy should have deterministic address");
    }

    function testRevertOnRedeployment() public {
        bytes32 salt = keccak256("test_revert_redeploy");
        bytes memory creationCode = type(TestImplementation).creationCode;
        bytes memory initializerData = abi.encodeWithSignature("initialize(uint256)", 42);

        CREATE3UUPSProxy.deploy(salt, creationCode, initializerData);

        vm.expectRevert();
        CREATE3UUPSProxy.deploy(salt, creationCode, initializerData);
    }
}
