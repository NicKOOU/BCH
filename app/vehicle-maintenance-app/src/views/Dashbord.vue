<template>
    <div>
        <h1>Vehicle Maintenance Dashboard</h1>
        <VehicleForm />
        <MaintenanceRequestForm />
        <MaintenanceHistory />
        <!-- ... other components -->
    </div>
</template>

<script>
import VehicleForm from "@/components/VehicleForm.vue";
import MaintenanceRequestForm from "@/components/MaintenanceRequestForm.vue";
import MaintenanceHistory from "@/components/MaintenanceHistory.vue";

export default {
    name: "Dashboard",
    components: {
        VehicleForm,
        MaintenanceRequestForm,
        MaintenanceHistory,
        // ... other components
    },
};
</script>

<style scoped>
/* Add your component-specific styles here */
</style>
