<template>
    <h1>Maintenance History</h1>
    <!-- Your table goes here -->
</template>

<script>
export default {
    name: "MaintenanceHistory",
    data() {
        return {
            maintenanceHistory: [],
        };
    },
    methods: {
        getMaintenanceHistory() {
            // Call your contract service to get maintenance history
        },
    },
    created() {
        this.getMaintenanceHistory();
    },
};
</script>