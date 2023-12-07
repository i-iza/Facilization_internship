window.femaleCount = 0;
window.maleCount = 0;
window.notSpecifiedCount = 0;

define(['knockout',
'ojs/ojarraydataprovider',
'sharedService',
'ojs/ojchart',
"ojs/ojbootstrap"],

 function(ko, ArrayDataProvider, sharedService,ojbootstrap_1) { 

    function DashboardViewModel (){
          
        const dataArray = [
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

        this.dataProvider = new ArrayDataProvider(dataArray, {
            keyAttributes: "id",
        });



        sharedService.subscribe('dataChangeEvent', (dataReceived) => {
            // Handle the received data here
            console.log('Received data:', dataReceived);
            if (dataReceived.gender === 'Male') {
                maleCount += 1;
            } else if (dataReceived.gender === 'Female') {
                femaleCount += 1;
            } else if (dataReceived.gender === 'Not Specified'){
                notSpecifiedCount += 1;
            }
            const updatedDataArray = [
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

            this.dataProvider = new ArrayDataProvider(updatedDataArray, {
                keyAttributes: "id",
            });

        });
        
    }
    document.addEventListener('DOMContentLoaded', function () {
        const viewModel = new DashboardViewModel();
        ko.applyBindings(viewModel, document.getElementById("chart-container"));
    });

    return DashboardViewModel;
}  
);