// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "@openzeppelin/contracts/access/Ownable.sol";

import "./Box.sol";

interface box {
    function requestReject(address user, uint256 index) external;

    function requestAutoAccept(address user, uint256 index) external;

    function checkRequestedAccessList()
        external
        view
        returns (address[] memory);
}

contract Subscription is Ownable {
    Box boxContract;

    // Subscription parameters
    struct subscriptionPlans {
        uint256 price;
        uint256 storageAvailable;
    }

    // User subscription details
    struct userBoxDetails {
        subscriptionPlans plan;
        address boxAddress;
    }

    subscriptionPlans[] public packages;

    // mappings
    mapping(address => bool) isSubscribed;
    mapping(address => subscriptionPlans[]) UserOwnedBoxes;
    mapping(address => userBoxDetails[]) subscriberToBox;
    mapping(address => bool) isAllowForBoxCall;

    // Define constructor to set subscription parameters
    constructor() {
        packages.push(subscriptionPlans(100, 10 * 1024));
        packages.push(subscriptionPlans(200, 50 * 1024));
        packages.push(subscriptionPlans(300, 100 * 1024));
    }

    //- - - - - S U B S C R I P T I O N   M A N A G E M E N T  -  F U N C T I O N S - - - - -

    // Function to get subscription plan details
    function getSubscriptionPlanDetails(uint256 package)
        public
        view
        returns (subscriptionPlans memory)
    {
        require(package < packages.length, "Package details not Available");
        return packages[package];
    }

    // Function to update subscription plan
    function updateSubscriptionPlan(
        uint256 index,
        uint256 newPrice,
        uint256 newStorage
    ) public onlyOwner {
        packages[index].price = newPrice;
        packages[index].storageAvailable = newStorage * 1024 * 1024;
    }

    // Function to create new subscription plan
    function createNewSubscriptionPlan(uint256 newPrice, uint256 newStorage)
        public
        onlyOwner
    {
        packages.push(subscriptionPlans(newPrice, newStorage * 1024 * 1024));
    }

    // Function to Remove subscription plan
    function removeSubscriptionPlan(uint256 index) public onlyOwner {
        packages[index] = packages[packages.length - 1];
        packages.pop();
    }

    // Function to return total subscription plans
    function totalSubscriptionPlans() public view returns (uint256) {
        return (packages.length);
    }

    // - - - - -   S U B S C R I B E  /  U N S U B S C R I B E  -  F U N C T I O N S   - - - - -

    // Subscription function
    function subscribe(uint256 package) public payable returns (address) {
        require(
            msg.value == packages[package].price,
            "Invalid subscription price"
        );
        if (!isSubscribed[msg.sender]) isSubscribed[msg.sender] = true;

        boxContract = new Box(
            packages[package].storageAvailable,
            msg.sender,
            address(this)
        );

        UserOwnedBoxes[msg.sender].push(
            subscriptionPlans(
                packages[package].price,
                packages[package].storageAvailable
            )
        );

        subscriberToBox[msg.sender].push(
            userBoxDetails(
                subscriptionPlans(
                    packages[package].price,
                    packages[package].storageAvailable
                ),
                address(boxContract)
            )
        );
        return (address(boxContract));
    }

    // Function to check subscription status of specific User
    function checkSubscriptionStatus(address user)
        public
        view
        returns (
            // allowedUser(user)
            bool
        )
    {
        return isSubscribed[user];
    }

    // - - - - -   U S E R   I N F O   -   F U N C T I O N S   - - - - -

    // Function to get All Owned Boxes of User
    function getUserAllBoxes(address user)
        public
        view
        returns (
            // allowedUser(user)
            subscriptionPlans[] memory
        )
    {
        return UserOwnedBoxes[user];
    }

    // Function to get All Owned Boxes Addresses of User
    function getUserAllBoxesInfo(address user)
        public
        view
        allowedUser(user)
        returns (userBoxDetails[] memory)
    {
        return subscriberToBox[user];
    }

    // Function to get Owned Box of User by its Index
    function getUserBoxByIndex(address user, uint256 index)
        public
        view
        returns (
            // allowedUser(user)
            userBoxDetails memory
        )
    {
        require(index < UserOwnedBoxes[user].length, "Box info not available");
        return subscriberToBox[user][index];
    }

    // Function to get user owned Box storage by index
    function getBoxMemorybyIndex(address user, uint256 index)
        public
        view
        returns (
            // allowedUser(user)
            uint256
        )
    {
        require(index < UserOwnedBoxes[user].length, "Box info not available");
        return UserOwnedBoxes[user][index].storageAvailable;
    }

    // Function to Reject Request for specific box
    function autoAllowAccessForSpecificBox(
        address boxAddress,
        address user,
        uint256 index
    ) public AllowedForBoxCall {
        box(boxAddress).requestAutoAccept(user, index);
    }

    // Function to Auto Approve Request for specific box
    function rejectAllowAccessForSpecificBox(
        address boxAddress,
        address user,
        uint256 index
    ) public AllowedForBoxCall {
        box(boxAddress).requestReject(user, index);
    }

    // Function to Allow Users to call requestReject Function of specific box
    function allowToCallBoxFunctions(address allow) public onlyOwner {
        isAllowForBoxCall[allow] = true;
    }

    // Function to disAllow Users to call requestReject Function of specific box
    function disAllowToCallBoxFunctions(address allow) public onlyOwner {
        isAllowForBoxCall[allow] = false;
    }

    // Function to Get Requested List of specific box
    function getRequestedAccessListOfBox(address boxAddress)
        public
        view
        returns (
            // AllowedForBoxCall
            address[] memory
        )
    {
        return box(boxAddress).checkRequestedAccessList();
    }

    // Modifier to call only by owner and Allowed User
    modifier allowedUser(address user) {
        require(
            msg.sender == owner() || user == msg.sender,
            "User not Allowed"
        );
        _;
    }

    modifier AllowedForBoxCall() {
        require(
            msg.sender == owner() || isAllowForBoxCall[msg.sender],
            "user not allowed to call these functions"
        );
        _;
    }
}
