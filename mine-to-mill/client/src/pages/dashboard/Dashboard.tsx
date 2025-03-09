import React from 'react';
import {
    Box,
    Card,
    CardContent,
    Grid,
    Typography,
    Paper,
    Divider
} from '@mui/material';
import MainLayout from '../../components/layout/MainLayout';

const Dashboard: React.FC = () => {
    // Placeholder data - would come from API in real implementation
    const reconciliationFactors = {
        mineClaimFactor: 0.95,
        metalCallFactor: 0.92,
    };

    const stockpileTonnage = {
        satellite: 25000,
        rom: 15000,
        crushedOre: 8000,
    };

    return (
        <MainLayout>
            <Box sx={{ flexGrow: 1 }}>
                <Typography variant="h4" gutterBottom component="div">
                    Dashboard
                </Typography>
                <Typography variant="subtitle1" gutterBottom component="div" color="text.secondary">
                    Overview of Mine to Mill Reconciliation
                </Typography>

                <Grid container spacing={3} sx={{ mt: 1 }}>
                    {/* Reconciliation Factors Card */}
                    <Grid item xs={12} md={6}>
                        <Card>
                            <CardContent>
                                <Typography variant="h6" gutterBottom>
                                    Reconciliation Factors
                                </Typography>
                                <Divider sx={{ mb: 2 }} />
                                <Grid container spacing={2}>
                                    <Grid item xs={6}>
                                        <Paper elevation={0} sx={{ p: 2, bgcolor: 'background.default' }}>
                                            <Typography variant="body2" color="text.secondary">
                                                Mine Claim Factor
                                            </Typography>
                                            <Typography variant="h4" color={reconciliationFactors.mineClaimFactor >= 0.95 ? 'success.main' : 'error.main'}>
                                                {reconciliationFactors.mineClaimFactor.toFixed(2)}
                                            </Typography>
                                        </Paper>
                                    </Grid>
                                    <Grid item xs={6}>
                                        <Paper elevation={0} sx={{ p: 2, bgcolor: 'background.default' }}>
                                            <Typography variant="body2" color="text.secondary">
                                                Metal Call Factor
                                            </Typography>
                                            <Typography variant="h4" color={reconciliationFactors.metalCallFactor >= 0.90 ? 'success.main' : 'error.main'}>
                                                {reconciliationFactors.metalCallFactor.toFixed(2)}
                                            </Typography>
                                        </Paper>
                                    </Grid>
                                </Grid>
                            </CardContent>
                        </Card>
                    </Grid>

                    {/* Stockpile Levels Card */}
                    <Grid item xs={12} md={6}>
                        <Card>
                            <CardContent>
                                <Typography variant="h6" gutterBottom>
                                    Current Stockpile Levels
                                </Typography>
                                <Divider sx={{ mb: 2 }} />
                                <Grid container spacing={2}>
                                    <Grid item xs={4}>
                                        <Paper elevation={0} sx={{ p: 2, bgcolor: 'background.default' }}>
                                            <Typography variant="body2" color="text.secondary">
                                                Satellite
                                            </Typography>
                                            <Typography variant="h5">
                                                {stockpileTonnage.satellite.toLocaleString()} t
                                            </Typography>
                                        </Paper>
                                    </Grid>
                                    <Grid item xs={4}>
                                        <Paper elevation={0} sx={{ p: 2, bgcolor: 'background.default' }}>
                                            <Typography variant="body2" color="text.secondary">
                                                ROM
                                            </Typography>
                                            <Typography variant="h5">
                                                {stockpileTonnage.rom.toLocaleString()} t
                                            </Typography>
                                        </Paper>
                                    </Grid>
                                    <Grid item xs={4}>
                                        <Paper elevation={0} sx={{ p: 2, bgcolor: 'background.default' }}>
                                            <Typography variant="body2" color="text.secondary">
                                                Crushed Ore
                                            </Typography>
                                            <Typography variant="h5">
                                                {stockpileTonnage.crushedOre.toLocaleString()} t
                                            </Typography>
                                        </Paper>
                                    </Grid>
                                </Grid>
                            </CardContent>
                        </Card>
                    </Grid>

                    {/* Recent Activity Card */}
                    <Grid item xs={12}>
                        <Card>
                            <CardContent>
                                <Typography variant="h6" gutterBottom>
                                    Recent Activity
                                </Typography>
                                <Divider sx={{ mb: 2 }} />
                                <Typography variant="body1" color="text.secondary">
                                    No recent activity to display. Monthly data uploads will appear here.
                                </Typography>
                            </CardContent>
                        </Card>
                    </Grid>
                </Grid>
            </Box>
        </MainLayout>
    );
};

export default Dashboard;
