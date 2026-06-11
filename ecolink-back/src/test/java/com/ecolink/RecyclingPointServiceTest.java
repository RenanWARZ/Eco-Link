package com.ecolink;

import com.ecolink.model.RecyclingPoint;
import com.ecolink.repository.RecyclingPointRepository;
import com.ecolink.service.RecyclingPointService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


public class RecyclingPointServiceTest {

    @Mock
    private RecyclingPointRepository recyclingPointRepository;

    @InjectMocks
    private RecyclingPointService recyclingPointService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    /**
     * Teste: Criar ponto de reciclagem
     */
    @Test
    public void testCreateRecyclingPoint() {
        RecyclingPoint point = RecyclingPoint.builder()
                .name("Ponto Central")
                .address("Rua A, 123")
                .latitude(-23.5505)
                .longitude(-46.6333)
                .types("[\"plástico\", \"papel\"]")
                .capacity(1000)
                .currentLoad(500)
                .isActive(true)
                .build();

        when(recyclingPointRepository.save(point)).thenReturn(point);

        RecyclingPoint created = recyclingPointService.create(point);

        assertNotNull(created);
        assertEquals("Ponto Central", created.getName());
        verify(recyclingPointRepository, times(1)).save(point);
    }

    /**
     * Teste: Obter pontos ativos
     */
    @Test
    public void testGetAllActive() {
        RecyclingPoint point1 = RecyclingPoint.builder()
                .id(1L)
                .name("Ponto 1")
                .isActive(true)
                .build();

        RecyclingPoint point2 = RecyclingPoint.builder()
                .id(2L)
                .name("Ponto 2")
                .isActive(true)
                .build();

        when(recyclingPointRepository.findByIsActiveTrue()).thenReturn(Arrays.asList(point1, point2));

        List<RecyclingPoint> points = recyclingPointService.getAllActive();

        assertEquals(2, points.size());
        verify(recyclingPointRepository, times(1)).findByIsActiveTrue();
    }

    /**
     * Teste: Calcular taxa de ocupação
     */
    @Test
    public void testOccupancyRate() {
        RecyclingPoint point = RecyclingPoint.builder()
                .name("Ponto Teste")
                .capacity(1000)
                .currentLoad(500)
                .build();

        Double occupancy = point.getOccupancyRate();

        assertEquals(50.0, occupancy);
    }

    /**
     * Teste: Verificar se ponto está cheio
     */
    @Test
    public void testIsFull() {
        RecyclingPoint point = RecyclingPoint.builder()
                .name("Ponto Cheio")
                .capacity(1000)
                .currentLoad(950)
                .build();

        assertTrue(point.isFull());
    }

    /**
     * Teste: Obter pontos próximos
     */
    @Test
    public void testGetNearby() {
        RecyclingPoint point1 = RecyclingPoint.builder()
                .id(1L)
                .name("Ponto Próximo")
                .latitude(-23.5505)
                .longitude(-46.6333)
                .isActive(true)
                .build();

        when(recyclingPointRepository.findByIsActiveTrue()).thenReturn(Arrays.asList(point1));

        List<RecyclingPoint> nearby = recyclingPointService.getNearby(-23.5505, -46.6333, 5.0);

        assertNotNull(nearby);
        verify(recyclingPointRepository, times(1)).findByIsActiveTrue();
    }
}
