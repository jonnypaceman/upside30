import React, { useState } from 'react';
import {
    Box,
    Button,
    Card,
    CardContent,
    Container,
    TextField,
    Typography,
    Grid,
    Link,
    Paper,
    useTheme
} from '@mui/material';
import { useNavigate } from 'react-router-dom';

const Login: React.FC = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();
    const theme = useTheme();

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setError('');

        // This is a placeholder for actual authentication logic
        // In a real implementation, this would call an authentication service
        if (email && password) {
            // Simulate successful login
            navigate('/');
        } else {
            setError('Please enter both email and password');
        }
    };

    return (
        <Box
            sx={{
                minHeight: '100vh',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: theme.palette.background.default,
            }}
        >
            <Container maxWidth="sm">
                <Paper
                    elevation={3}
                    sx={{
                        borderRadius: 2,
                        overflow: 'hidden',
                    }}
                >
                    <Grid container>
                        <Grid item xs={12} sx={{ bgcolor: theme.palette.primary.main, p: 3, textAlign: 'center' }}>
                            <Typography variant="h4" component="h1" color="white">
                                Mine to Mill
                            </Typography>
                            <Typography variant="subtitle1" color="white" sx={{ opacity: 0.8 }}>
                                Reconciliation System
                            </Typography>
                        </Grid>
                        <Grid item xs={12}>
                            <CardContent sx={{ p: 4 }}>
                                <Typography variant="h5" component="div" gutterBottom>
                                    Sign In
                                </Typography>
                                <Typography variant="body2" color="text.secondary" gutterBottom>
                                    Enter your credentials to access your account
                                </Typography>

                                {error && (
                                    <Typography color="error" variant="body2" sx={{ mt: 2 }}>
                                        {error}
                                    </Typography>
                                )}

                                <Box component="form" onSubmit={handleSubmit} sx={{ mt: 3 }}>
                                    <TextField
                                        margin="normal"
                                        required
                                        fullWidth
                                        id="email"
                                        label="Email Address"
                                        name="email"
                                        autoComplete="email"
                                        autoFocus
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                    />
                                    <TextField
                                        margin="normal"
                                        required
                                        fullWidth
                                        name="password"
                                        label="Password"
                                        type="password"
                                        id="password"
                                        autoComplete="current-password"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                    />
                                    <Button
                                        type="submit"
                                        fullWidth
                                        variant="contained"
                                        sx={{ mt: 3, mb: 2 }}
                                    >
                                        Sign In
                                    </Button>
                                    <Grid container justifyContent="flex-end">
                                        <Grid item>
                                            <Link href="#" variant="body2">
                                                Forgot password?
                                            </Link>
                                        </Grid>
                                    </Grid>
                                </Box>
                            </CardContent>
                        </Grid>
                    </Grid>
                </Paper>
                <Box sx={{ mt: 2, textAlign: 'center' }}>
                    <Typography variant="body2" color="text.secondary">
                        © {new Date().getFullYear()} Mine to Mill Reconciliation System
                    </Typography>
                </Box>
            </Container>
        </Box>
    );
};

export default Login;
