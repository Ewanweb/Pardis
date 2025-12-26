const API_BASE = "https://api.pardistous.ir/api";

const endpoints = [
  { name: "Health Check", method: "GET", url: "/Health" },
  { name: "Courses", method: "GET", url: "/Home/Courses" },
  { name: "Categories", method: "GET", url: "/Home/Categories" },
  { name: "Instructors", method: "GET", url: "/Home/Instructors" },
  { name: "Hero Slides (All)", method: "GET", url: "/HeroSlides" },
  { name: "Hero Slides (Active)", method: "GET", url: "/HeroSlides/active" },
  { name: "Success Stories (All)", method: "GET", url: "/SuccessStories" },
  {
    name: "Success Stories (Active)",
    method: "GET",
    url: "/SuccessStories/active",
  },
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
      console.log(`✅ Success - Data structure:`);

      // Check if it's a wrapped response
      if (data.success !== undefined) {
        console.log(
          `📦 Wrapped Response: success=${data.success}, message="${data.message}"`
        );
        if (data.data) {
          const actualData = data.data;
          if (Array.isArray(actualData)) {
            console.log(`📋 Array length: ${actualData.length}`);
            if (actualData.length > 0) {
              console.log(
                `🔍 First item keys: ${Object.keys(actualData[0]).join(", ")}`
              );
              // Show sample data to verify it's not static
              if (actualData[0].title) {
                console.log(`📝 Sample title: "${actualData[0].title}"`);
              }
              if (actualData[0].id) {
                console.log(`🆔 Sample ID: ${actualData[0].id}`);
              }
            }
          } else {
            console.log(`🔍 Data keys: ${Object.keys(actualData).join(", ")}`);
          }
        }
      } else if (data.data) {
        // Check if it has a data property
        const actualData = data.data;
        if (Array.isArray(actualData)) {
          console.log(`📋 Array length: ${actualData.length}`);
          if (actualData.length > 0) {
            console.log(
              `🔍 First item keys: ${Object.keys(actualData[0]).join(", ")}`
            );
          }
        }
      } else if (Array.isArray(data)) {
        console.log(`📋 Direct array length: ${data.length}`);
        if (data.length > 0) {
          console.log(`🔍 First item keys: ${Object.keys(data[0]).join(", ")}`);
        }
      } else {
        console.log(`🔍 Object keys: ${Object.keys(data).join(", ")}`);
      }

      return { success: true, data, status: response.status };
    } else {
      const errorText = await response.text();
      console.log(`❌ Failed: ${errorText.substring(0, 200)}...`);
      return { success: false, error: errorText, status: response.status };
    }
  } catch (error) {
    console.log(`💥 Network Error: ${error.message}`);
    return { success: false, error: error.message, status: 0 };
  }
}

async function testCorrectedEndpoints() {
  console.log("🔍 Testing Corrected API Endpoints");
  console.log("=".repeat(60));

  const results = [];

  for (const endpoint of endpoints) {
    const result = await testEndpoint(endpoint);
    results.push({ endpoint: endpoint.name, ...result });
    await new Promise((resolve) => setTimeout(resolve, 500));
  }

  console.log("\n📋 FINAL SUMMARY");
  console.log("=".repeat(60));

  const successful = results.filter((r) => r.success);
  const failed = results.filter((r) => !r.success);

  console.log(`✅ Working Endpoints: ${successful.length}/${results.length}`);
  console.log(`❌ Failed Endpoints: ${failed.length}/${results.length}`);

  if (successful.length > 0) {
    console.log("\n✅ WORKING ENDPOINTS (Real Data):");
    successful.forEach((s) => {
      console.log(`  ✓ ${s.endpoint}: Status ${s.status}`);
    });
  }

  if (failed.length > 0) {
    console.log("\n❌ FAILED ENDPOINTS:");
    failed.forEach((f) => {
      console.log(
        `  ✗ ${f.endpoint}: ${f.status} - ${
          f.error?.substring(0, 100) || "Unknown error"
        }...`
      );
    });
  }

  console.log("\n🎯 RECOMMENDATION:");
  if (successful.length >= 4) {
    console.log(
      "✅ Most endpoints are working with real data. Debug console is ready!"
    );
  } else {
    console.log(
      "⚠️  Some endpoints need database fixes or deployment updates."
    );
  }
}

testCorrectedEndpoints().catch(console.error);
