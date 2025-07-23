Refactor

-------


- when stubbing do not specify resolves because it introduces a default behavior across all blocks within

Example:

  describe("#getLocationDetails", () => {
    let getLatLngWithPostalCodeStub: sinon.SinonStub;

    beforeEach(async () => {
      getLatLngWithPostalCodeStub = sandbox.stub(Location, "getLatLngWithPostalCode");
      getLatLngWithPostalCodeStub.resolves({ lat: 1, lng: 2 });
    });

    it("should call getLatLngWithPostalCode if lat lng does not exist and return", async () => {
    })

refactor:

  describe("#getLocationDetails", () => {
    let getLatLngWithPostalCodeStub: sinon.SinonStub;

    beforeEach(async () => {
      getLatLngWithPostalCodeStub = sandbox.stub(Location, "getLatLngWithPostalCode");
    });

    it("should call getLatLngWithPostalCode if lat lng does not exist and return", async () => {
      getLatLngWithPostalCodeStub.resolves({ lat: 1, lng: 2 });
    })