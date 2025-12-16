import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {

  const productType = document.getElementById("product_type_select");
  if (!productType) return;

  const brandSelect = document.getElementById("brand_select");
  const modelSelect = document.getElementById("model_select");

  const brandText = document.getElementById("brand_text");
  const modelText = document.getElementById("model_text");

  const brandDropdownWrapper = document.getElementById("brand_dropdown_wrapper");
  const brandTextWrapper = document.getElementById("brand_text_wrapper");
  const modelDropdownWrapper = document.getElementById("model_dropdown_wrapper");
  const modelTextWrapper = document.getElementById("model_text_wrapper");

  const dropdownCategories = [
    "Mobile Phones",
    "Laptops",
    "Tablets",
    "Televisions",
    "Washing Machine",
    "Fridge",
    "AC",
    "Inverter Batteries"
  ];

  const brandsByProduct = {
    "Mobile Phones": ["Apple", "Samsung", "OnePlus", "Xiaomi"],
    "Laptops": ["Dell", "HP", "Lenovo", "Apple"],
    "Tablets": ["Apple", "Samsung"],
    "Televisions": ["Sony", "Samsung", "LG"],
    "Washing Machine": ["LG", "Samsung", "Whirlpool", "Bosch"],
    "Fridge": ["LG", "Samsung", "Whirlpool", "Godrej"],
    "AC": ["LG", "Samsung", "Daikin", "Voltas"],
    "Inverter Batteries": ["Exide", "Luminous", "Amaron", "Livguard", "Okaya"]
  };

  const modelsByCategoryAndBrand = {
    "Mobile Phones": {
      "Apple": ["iPhone 13", "iPhone 14", "iPhone 15"],
      "Samsung": ["Galaxy S21", "Galaxy S22", "Galaxy S23"],
      "OnePlus": ["OnePlus 10", "OnePlus 11"],
      "Xiaomi": ["Redmi Note 12", "Mi 11"]
    },

    "Laptops": {
      "Apple": ["MacBook Air", "MacBook Pro"],
      "Dell": ["Inspiron", "XPS", "Latitude"],
      "HP": ["Pavilion", "Envy"],
      "Lenovo": ["ThinkPad", "IdeaPad"]
    },

    "Tablets": {
      "Apple": ["iPad 10th Gen", "iPad Air"],
      "Samsung": ["Galaxy Tab S7", "Galaxy Tab S8"]
    },

    "Televisions": {
      "Samsung": ["Crystal UHD", "Neo QLED"],
      "Sony": ["Bravia X75", "Bravia X90"],
      "LG": ["OLED", "NanoCell"]
    },

    "Washing Machine": {
      "Samsung": ["Front Load", "Top Load", "Eco Bubble"],
      "LG": ["Front Load", "Top Load"],
      "Whirlpool": ["Fully Automatic", "Semi Automatic"],
      "Bosch": ["Series 4", "Series 6"]
    },

    "Fridge": {
      "Samsung": ["Single Door", "Double Door", "Side by Side"],
      "LG": ["Single Door", "Double Door"],
      "Whirlpool": ["IntelliFresh", "Protton"],
      "Godrej": ["Eon", "Pro Series"]
    },

    "AC": {
      "Samsung": ["WindFree AC", "Split AC"],
      "LG": ["Dual Inverter", "Split AC"],
      "Daikin": ["Inverter AC", "Split AC"],
      "Voltas": ["Window AC", "Split AC"]
    },

    "Inverter Batteries": {
      "Exide": ["Inva Master", "Tubular 150Ah", "Tubular 200Ah"],
      "Luminous": ["RC18000", "RC25000", "Tall Tubular"],
      "Amaron": ["Quanta", "Tall Tubular"],
      "Livguard": ["LGTT 180Ah", "LGTT 200Ah"],
      "Okaya": ["OPJT180", "OPJT200"]
    }
  };

  function enableDropdowns() {
    brandDropdownWrapper.style.display = "block";
    modelDropdownWrapper.style.display = "block";
    brandTextWrapper.style.display = "none";
    modelTextWrapper.style.display = "none";

    brandSelect.disabled = false;
    modelSelect.disabled = false;
    brandText.disabled = true;
    modelText.disabled = true;
  }

  function enableTextInputs() {
    brandDropdownWrapper.style.display = "none";
    modelDropdownWrapper.style.display = "none";
    brandTextWrapper.style.display = "block";
    modelTextWrapper.style.display = "block";

    brandSelect.disabled = true;
    modelSelect.disabled = true;
    brandText.disabled = false;
    modelText.disabled = false;
  }

  function populateBrands(category) {
    brandSelect.innerHTML = '<option value="">Select Brand</option>';
    (brandsByProduct[category] || []).forEach((brand) => {
      brandSelect.add(new Option(brand, brand));
    });
  }

  function populateModels(category, brand) {
    modelSelect.innerHTML = '<option value="">Select Model</option>';
    (modelsByCategoryAndBrand[category]?.[brand] || []).forEach((model) => {
      modelSelect.add(new Option(model, model));
    });
  }

  function setupDropdowns() {
    const category = productType.value;
    const savedBrand = brandSelect.dataset.value;
    const savedModel = modelSelect.dataset.value;

    if (dropdownCategories.includes(category)) {
      enableDropdowns();
      populateBrands(category);

      if (savedBrand) {
        brandSelect.value = savedBrand;
        populateModels(category, savedBrand);
      }

      if (savedModel) {
        modelSelect.value = savedModel;
      }

    } else {
      enableTextInputs();
    }
  }

  productType.addEventListener("change", () => {
    brandSelect.dataset.value = "";
    modelSelect.dataset.value = "";
    setupDropdowns();
  });

  brandSelect.addEventListener("change", () => {
    populateModels(productType.value, brandSelect.value);
  });

  setupDropdowns();
});
