namespace BusTicketManagement.Domain.Entities
{
    public class Booking
    {
        public int BookingId { get; set; }
        public string BookingNumber { get; set; } = string.Empty;
        public string UserId { get; set; } = string.Empty;
        public int ScheduleId { get; set; }
        public int FromSegmentId { get; set; }
        public int ToSegmentId { get; set; }
        public DateTime BookingDate { get; set; }
        public string BookingStatus { get; set; } = "Confirmed";
        public string PassengerName { get; set; } = string.Empty;
        public string? PassengerEmail { get; set; }
        public string? PassengerPhone { get; set; }
        public decimal TotalFare { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal FinalFare { get; set; }
        public DateTime? CancellationDate { get; set; }
        public decimal RefundAmount { get; set; }
        public string? CancellationReason { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
    }
}