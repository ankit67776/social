import { Controller } from "@hotwired/stimulus";
import Chart from "chart.js/auto";

export default class extends Controller {
  connect() {
    const ctx = document.getElementById("incomePieChart").getContext("2d");

    new Chart(ctx, {
      type: "pie",
      data: {
        labels: ["Income", "Expenses"],
        datasets: [
          {
            data: [60, 40], // Adjust values here
            backgroundColor: ["#2563EB", "#EF4444"], // Blue and Red
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false },
        },
      },
    });
  }
}
