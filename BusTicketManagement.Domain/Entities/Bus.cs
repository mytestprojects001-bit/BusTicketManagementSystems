namespace BusTicketManagement.Domain.Entities
{
    public class Bus
    {
        public int BusId { get; set; }
        public string BusNo { get; set; } = string.Empty;
        public string BusType { get; set; } = string.Empty;
        public int Capacity { get; set; }
        public string CurrentStatus { get; set; } = "Active";
        public string? ManufacturerName { get; set; }
        public DateTime? RegistrationDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool IsActive { get; set; } = true;
    }
}