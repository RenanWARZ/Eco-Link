package com.ecolink;

import com.ecolink.model.User;
import com.ecolink.repository.UserRepository;
import com.ecolink.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    /**
     * Teste: Criar novo usuário
     */
    @Test
    public void testCreateUser() {
        User user = User.builder()
                .openId("user123")
                .name("João Silva")
                .email("joao@email.com")
                .role(User.UserRole.CITIZEN)
                .points(0)
                .build();

        when(userRepository.save(user)).thenReturn(user);

        User created = userService.createOrUpdateUser(user);

        assertNotNull(created);
        assertEquals("user123", created.getOpenId());
        assertEquals("João Silva", created.getName());
        verify(userRepository, times(1)).save(user);
    }

    /**
     * Teste: Obter usuário por OpenId
     */
    @Test
    public void testGetUserByOpenId() {
        User user = User.builder()
                .id(1L)
                .openId("user123")
                .name("João Silva")
                .build();

        when(userRepository.findByOpenId("user123")).thenReturn(Optional.of(user));

        Optional<User> found = userService.getUserByOpenId("user123");

        assertTrue(found.isPresent());
        assertEquals("João Silva", found.get().getName());
    }

    /**
     * Teste: Atualizar pontos do usuário
     */
    @Test
    public void testUpdateUserPoints() {
        User user = User.builder()
                .id(1L)
                .openId("user123")
                .name("João Silva")
                .points(100)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userRepository.save(user)).thenReturn(user);

        User updated = userService.updateUserPoints(1L, 50);

        assertEquals(150, updated.getPoints());
        verify(userRepository, times(1)).save(user);
    }

    /**
     * Teste: Usuário não encontrado
     */
    @Test
    public void testUserNotFound() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> {
            userService.updateUserPoints(999L, 50);
        });
    }
}
