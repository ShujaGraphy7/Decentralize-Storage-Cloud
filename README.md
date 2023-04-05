### ----- Contracts -----
#### i.     Box.
#### ii.    Subscription Management

#### 1. Subscription Contract

    i. SUBSCRIPTION MANAGEMENT FUNCTIONS
        - Admin can update subscription plans.
        - Admin can create new subscription plan.
        - Admin can delete any previous defined subscription plan.
        - users can get subscription details.

    ii. Subscribe Function
        - user can subscribe to any defined package.
        - when user purchase the subscription then a new box contract address is assign to that user by which user can manage there box.

    iii.Check Subscription Status Function
        - users can check if they have any box access.

    iv. Update Owner Functions
        - Admin can assign new admin.
        - user can check current Admin address.

    v. User info Functions
        - user can get all plans info they have subscribed.
        - users can get addresses of all owned boxex
        - user can get box info by its index
        - user can get storage info of specific box by index 
    
    vi. Request will auto accept by subscription contract if not accepted twice.

#### 2. Box Contract

    i.  Add Files function
        - user can add files to there assigned box.
        - contract will check if they have enough storage availabe in there package.

    ii. Read Functions
        - Allowed user / owner can get files by id
        - Allowed user / owner can get all files availabe in this box
        - allowed users can also read these files

    iii.Allow user Function
        - box admin can allow the users to access the box
        - box admin can remove allowed users.
        - users can check if they are allowed to access the box

    iv. check Storage Function
        - admin can get total storage of box
        - admin can get used storage of the box

    v.  Request Access Functions
        - Any one Can Request to access Box
        - Admin can accept or ignore access request
        - Admin can check Request user List 
        - user can check there status of request

    vi. vi. Request will auto accept by box contract if not accepted twice.
<<<<<<< HEAD
    
=======
        - box admin can get total storage of box
        - box admin can get used storage of the box
        

#### Contract Addresses: 
        - Subscription: 0x7bb35231d5e49eb751864Ac04611e4a2900Bf66D
        - Box: 
            . aprox 10 MB boX Storage 0x6AbFD5439a1934Dad0D57A1852Eb555855fEA96c
            . Owner of testing Box is Faheem: 0x100b1CA1c2e4a468B21D3c8aF215940FD1E1fFc4
>>>>>>> 8e02f61ed6adceb6fead95c07c14f3f89dc6d071
