window.femaleCount = parseInt(sessionStorage.getItem('femaleCount')) || 0;
window.maleCount = parseInt(sessionStorage.getItem('maleCount')) || 0;
window.notSpecifiedCount = parseInt(sessionStorage.getItem('notSpecifiedCount')) || 0;
window.lastDataReceived = null; 

define(['knockout',
    'ojs/ojarraydataprovider',
    'sharedService',
    'ojs/ojchart',
    "ojs/ojbootstrap"],

    function (ko, ArrayDataProvider, sharedService) {

        function DashboardViewModel() {
            this.chartDataArray = [];
            this._initChart(this.chartDataArray);

        }
        /************************************************************
                     * @function _initChart
                     * @param {Array} dataArray - The array to be modified
                     * @description Initialize the chart
                     */

        DashboardViewModel.prototype._initChart = function (dataArray) {
            dataArray = [
                {
                    "id": 0,
                    "series": 'Males',
                    "group": "Group A",
                    "value": maleCount
                },
                {
                    "id": 1,
                    "series": "Females",
                    "group": "Group A",
                    "value": femaleCount
                },
                {
                    "id": 2,
                    "series": "Not Specified",
                    "group": "Group A",
                    "value": notSpecifiedCount
                }
            ];

            this.chartDataProvider = new ArrayDataProvider(dataArray, {
                keyAttributes: "id",
            });

            sharedService.subscribe('dataChangeEvent', (dataReceived) => {

                // Check if the received data is the same as the last data received
                if (JSON.stringify(dataReceived) === JSON.stringify(lastDataReceived)) {
                    console.log('Received duplicate data. Skipping...');
                    return;
                }
                console.log('Received data:', dataReceived);
                lastDataReceived = dataReceived; 

                // Update counts based on the current state of the data
                let updatedMaleCount = dataArray[0].value;
                let updatedFemaleCount = dataArray[1].value;
                let updatedNotSpecifiedCount = dataArray[2].value;

                if (dataReceived.gender === 'Male') {
                    updatedMaleCount += 1;
                } else if (dataReceived.gender === 'Female') {
                    updatedFemaleCount += 1;
                } else if (dataReceived.gender === 'Not Specified') {
                    updatedNotSpecifiedCount += 1;
                }

                // Update the specific data point in the array
                dataArray[0].value = updatedMaleCount;
                dataArray[1].value = updatedFemaleCount;
                dataArray[2].value = updatedNotSpecifiedCount;

                // Update the observable array directly
                this.chartDataProvider.options.data = dataArray;

                // Update the counts
                maleCount = updatedMaleCount;
                femaleCount = updatedFemaleCount;
                notSpecifiedCount = updatedNotSpecifiedCount;

                // Save counts to session storage
                sessionStorage.setItem('maleCount', maleCount);
                sessionStorage.setItem('femaleCount', femaleCount);
                sessionStorage.setItem('notSpecifiedCount', notSpecifiedCount);
            });


        };

        document.addEventListener('DOMContentLoaded', function () {
            const viewModel = new DashboardViewModel();
            viewModel._initChart();
            ko.applyBindings(viewModel, document.getElementById("chart-container"));
        });

        return DashboardViewModel;
    }
);
