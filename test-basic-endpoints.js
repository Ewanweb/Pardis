const API_BASE = "https://api.pardistous.ir/api";

// Test basic endpoints that should exist
const basicEndpoints = [
  { name: "Health Check", method: "GET", url: "/Health" },
  { name: "Courses", method: "GET", url: "/Courses" },
  // Try different variations of slider endpoints
  { name: "Sliders", method: "GET", url: "/Sliders" },
  { name: "Slider", method: "GET", url: "/Slider" },
  { name: "HeroSlider", method: "GET", url: "/HeroSlider" },
  { name: "Stories", method: "GET", url: "/Stories" },
  { name: "Story", method: "GET", url: "/Story" },
  { name: "SuccessStory", method: "GET", url: "/SuccessStory" },
];

async function testEndpoint(endpoint) {
  const url = `${API_BASE}${endpoint.url}`;
  console.log(`\n🧪 Testing: ${endpoint.name} - ${url}`);

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
      console.log(`✅ Success - Response structure:`);
      console.log(JSON.stringify(data, null, 2).substring(0, 500) + "...");
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

async function testBasicEndpoints() {
  console.log("🔍 Testing Basic API Endpoints");
  console.log("=".repeat(60));

  for (const endpoint of basicEndpoints) {
    await testEndpoint(endpoint);
    await new Promise((resolve) => setTimeout(resolve, 300));
  }
}

testBasicEndpoints().catch(console.error);
