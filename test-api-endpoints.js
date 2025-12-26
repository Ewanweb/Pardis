const API_BASE = "https://api.pardistous.ir/api";

const endpoints = [
  { name: "Health Check", method: "GET", url: "/Health" },
  { name: "Active Hero Slides", method: "GET", url: "/HeroSlides/active" },
  { name: "All Hero Slides", method: "GET", url: "/HeroSlides" },
  {
    name: "Active Success Stories",
    method: "GET",
    url: "/SuccessStories/active",
  },
  { name: "All Success Stories", method: "GET", url: "/SuccessStories" },
  { name: "Courses", method: "GET", url: "/Courses" },
  { name: "Categories", method: "GET", url: "/Categories" },
  { name: "Instructors", method: "GET", url: "/Instructors" },
];

async function testEndpoint(endpoint) {
  const url = `${API_BASE}${endpoint.url}`;
  console.log(`\n🧪 Testing: ${endpoint.name}`);
  console.log(`📍 URL: ${url}`);

  try {
    const response = await fetch(url, {
      method: endpoint.method,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
    });

    console.log(`📊 Status: ${response.status} ${response.statusText}`);

    if (response.ok) {
      const data = await response.json();
      console.log(
        `✅ Success - Data type: ${Array.isArray(data) ? "Array" : typeof data}`
      );

      if (Array.isArray(data)) {
        console.log(`📦 Array length: ${data.length}`);
        if (data.length > 0) {
          console.log(`🔍 First item keys: ${Object.keys(data[0]).join(", ")}`);
        }
      } else if (typeof data === "object" && data !== null) {
        console.log(`🔍 Object keys: ${Object.keys(data).join(", ")}`);
      }

      // Check if data looks static/fake
      if (Array.isArray(data) && data.length > 0) {
        const firstItem = data[0];
        if (firstItem.id && firstItem.title) {
          console.log(
            `📝 Sample: ID=${firstItem.id}, Title="${firstItem.title}"`
          );
        }
      }

      return { success: true, data, status: response.status };
    } else {
      console.log(`❌ Failed - ${response.status}`);
      const errorText = await response.text();
      console.log(`💬 Error: ${errorText}`);
      return { success: false, error: errorText, status: response.status };
    }
  } catch (error) {
    console.log(`💥 Network Error: ${error.message}`);
    return { success: false, error: error.message, status: 0 };
  }
}

async function testAllEndpoints() {
  console.log("🚀 Starting API Endpoint Tests");
  console.log("=".repeat(50));

  const results = [];

  for (const endpoint of endpoints) {
    const result = await testEndpoint(endpoint);
    results.push({ endpoint: endpoint.name, ...result });

    // Wait a bit between requests
    await new Promise((resolve) => setTimeout(resolve, 500));
  }

  console.log("\n📋 SUMMARY");
  console.log("=".repeat(50));

  const successful = results.filter((r) => r.success);
  const failed = results.filter((r) => !r.success);

  console.log(`✅ Successful: ${successful.length}/${results.length}`);
  console.log(`❌ Failed: ${failed.length}/${results.length}`);

  if (failed.length > 0) {
    console.log("\n❌ Failed Endpoints:");
    failed.forEach((f) => {
      console.log(`  - ${f.endpoint}: ${f.error || "Unknown error"}`);
    });
  }

  if (successful.length > 0) {
    console.log("\n✅ Successful Endpoints:");
    successful.forEach((s) => {
      console.log(`  - ${s.endpoint}: Status ${s.status}`);
    });
  }
}

// Run the tests
testAllEndpoints().catch(console.error);
