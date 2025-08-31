# Node.js Testing Refactor Guide

## Sinon Stubbing Best Practices

### Rule: Avoid Default Stub Behavior in `beforeEach`

When stubbing methods, avoid specifying `resolves()` or other behavior in `beforeEach` blocks, as this introduces default behavior that applies across all test cases within the describe block. This can lead to unexpected side effects and makes tests less explicit.

### ❌ Before (Problematic Pattern)

```javascript
describe("#getLocationDetails", () => {
  let getLatLngWithPostalCodeStub: sinon.SinonStub;

  beforeEach(async () => {
    getLatLngWithPostalCodeStub = sandbox.stub(Location, "getLatLngWithPostalCode");
    // ❌ Avoid: Default behavior applied to all tests
    getLatLngWithPostalCodeStub.resolves({ lat: 1, lng: 2 });
  });

  it("should call getLatLngWithPostalCode if lat lng does not exist and return", async () => {
    // Test logic here - but stub behavior is already defined above
  });
});
```

### ✅ After (Recommended Pattern)

```javascript
describe("#getLocationDetails", () => {
  let getLatLngWithPostalCodeStub: sinon.SinonStub;

  beforeEach(async () => {
    // ✅ Only create the stub, don't define behavior
    getLatLngWithPostalCodeStub = sandbox.stub(Location, "getLatLngWithPostalCode");
  });

  it("should call getLatLngWithPostalCode if lat lng does not exist and return", async () => {
    // ✅ Define stub behavior specific to this test
    getLatLngWithPostalCodeStub.resolves({ lat: 1, lng: 2 });
    
    // Test logic here
  });
});
```

### Benefits

- **Explicit behavior**: Each test clearly defines what the stub should return
- **Test isolation**: Tests don't depend on shared stub behavior
- **Easier debugging**: When a test fails, the stub behavior is visible in that specific test
- **Flexibility**: Different tests can easily use different stub behaviors

## Line Length and String Handling

### Rule: Don't Split Informational Strings

When dealing with long descriptive strings (like test descriptions), avoid breaking them with string concatenation. Keep informational content as a single readable string, even if it exceeds line length limits.

### ❌ Problematic: String Concatenation

```javascript
it("should call location service when postalCodeToLatLngMap does not contain " + 
        "PostalCode to latLng mapping", async () => {
  // Test logic here
});
```

**Issues:**

- Breaks readability of the test description
- Unnecessary string concatenation for static content
- Makes searching for test names more difficult

### ✅ Recommended: Single String

```javascript
it("should call location service when postalCodeToLatLngMap does not contain PostalCode to latLng mapping", 
      async () => {
  // Test logic here
});
```

**Benefits:**

- Test description remains as a single, searchable string
- Better readability and maintainability
- Easier to find tests by description