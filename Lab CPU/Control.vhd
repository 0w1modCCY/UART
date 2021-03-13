-- author: DATSI
-- http://www.datsi.fi.upm.es
-- License: GPLv3. See file: GPLv3License.txt

library IEEE;
use IEEE.std_logic_1164.all;
use work.auxiliary.all;

entity Control is
    generic (delay          :     time);
    port (
      -- Related to the ALU:
      ALUcontrol     : out std_logic_vector(3 downto 0);
      cin            : out std_logic;
      EnableALU      : out std_logic;
      --  Related to the register file:
      SourceA        : out std_logic_vector(2 downto 0);
      SourceB        : out std_logic_vector(2 downto 0);
      Dest           : out std_logic_vector(2 downto 0);
      EnableA        : out std_logic;
      EnableB        : out std_logic;
      LoadDest       : out std_logic;
      -- Related to the program counter:
      PCop           : out std_logic_vector(1 downto 0);
      EnablePC       : out std_logic;
      --  Related to the condition code register:
      ZNVC           : in  std_logic_vector(3 downto 0);
      LoadCCR        : out std_logic;
      CondHolds	     : in std_logic;
      --  Related to the instruction register:
      Opcode         : in  std_logic_vector(2 downto 0);
      OpCodeExt      : in  std_logic_vector(3 downto 0);
      SReg1          : in  std_logic_vector(2 downto 0);
      SReg2          : in  std_logic_vector(2 downto 0);
      DReg           : in  std_logic_vector(2 downto 0);
      LoadIReg       : out std_logic;
      EnableImmed    : out std_logic;
      EnableDisp     : out std_logic;
      --  Related to the tristate buffers interfacing memory:
      DriveMem       : out std_logic;
      DriveCPU       : out std_logic;  
      -- Related to the external memory:
      ReadMem        : out std_logic;
      WriteMem       : out std_logic;
      mhold          : in  std_logic;
      LoadMAR        : out std_logic;
      -- General:
      reset          : in std_logic; -- Low level active.
      clock          : in std_logic  -- Rising edge triggered.
      );
  end entity;


architecture Student of Control is

  type STATES is
    (Initial, ReadInst, Execution, ReadData, WriteData, GoTo, Halted, Error);

-- Signal declarations:
  signal PresentState : STATES:= Initial;
  signal FutureState : STATES;

begin

  Memory: process(clock, reset)
  begin
     if reset = '0' then
	PresentState <= Initial;

     elsif rising_edge(clock) then
	PresentState <= FutureState;
      
     end if;
  end process;

  Combinational: process(PresentState, ZNVC, CondHolds, Opcode, 
                         OpCodeExt, SReg1, SReg2, DReg, mhold)

  begin
   --Default value for OUTPUTS
   ALUcontrol  <= "0000";
   cin         <= '0';
   EnableALU   <= '0';
   SourceA     <= "000";
   SourceB     <= "000";
   Dest        <= "000";
   EnableA     <= '0';
   EnableB     <= '0';
   LoadDest    <= '0';
   PCop        <= "00";
   EnablePC    <= '0';
   LoadCCR     <= '0';
   LoadIReg    <= '0';
   EnableImmed <= '0';
   EnableDisp  <= '0';
   DriveMem    <= '0';
   DriveCPU    <= '0';
   ReadMem     <= '0';
   WriteMem    <= '0';
   LoadMAR     <= '0';

   case PresentState is
     when Initial =>
          EnablePC    <= '1';
          EnableALU   <= '1';
          LoadMAR     <= '1';
          ALUcontrol  <= PASS_A;
          PCop <= INCRPC;
          FutureState <= ReadInst;
     
     when ReadInst =>
          ReadMem     <= '1';
          DriveCPU    <= '1';
          LoadIReg     <= '1';

          if mhold='1'
           then FutureState <= Execution;
  
          else FutureState <= ReadInst;
         end if;
    
     when Execution =>
          case OpCode is

            --STOP instruction
            when STOPCODE =>
                 FutureState <= Halted;
            
            --IMMO instruction
            when IMMOCODE =>
                 EnableImmed <= '1';
                 
                 case OpCodeExt(1 downto 0) is
                   when LDIL =>
                        ALUcontrol <= PASS_B;

                   when LDIX =>
                        ALUcontrol <= PASS_B;
 
                   when ORIH =>
                        SourceA <= DReg;
                        EnableA <= '1';
                        ALUcontrol <= ALU_OR;
                 
                   when ADDIX =>
                        SourceA <= DReg;
                        EnableA <= '1';
                        ALUcontrol <= ALU_ADD;

                   when others => FutureState <= Error;
                  end case; --of OpCodeExt

                 EnableALU <= '1';
                 Dest <= DReg;
                 LoadDest <= '1';
                 FutureState <= Initial;

            --LOAD instruction
            when LOADCODE =>
                 SourceA <= SReg1;
                 EnableA <= '1';
                 SourceB <= SReg2;
                 EnableB <= '1';
                 ALUcontrol <= ALU_ADD;
                 EnableALU <= '1';
                 LoadMAR <= '1';
                 FutureState <= ReadData;

            --STORE instruction
            when STORECODE => 
                 SourceA <= SReg1;
                 EnableA <= '1';
                 SourceB <= SReg2;
                 EnableB <= '1';
                 ALUcontrol <= ALU_ADD;
                 EnableALU <= '1';
                 LoadMAR <= '1';
                 FutureState <= WriteData;

            --ADD instruction 
            when ADDCODE =>
                 SourceA <= SReg1;
                 EnableA <= '1';
                 SourceB <= SReg2;
                 EnableB <= '1';
                 cin <= (OpCodeExt(1) and ZNVC(0)) xor OpCodeExt(0);
                 ALUcontrol <= OpCodeExt(3) & OpCode;
                 LoadCCR <= OpCodeExt(2);
                 EnableALU <= '1';
                 Dest <= DReg;
                 LoadDest <= '1';
                 FutureState <= Initial;

            --OPLOGCODE instruction
            when OPLOGCODE =>
                 SourceA <= SReg1;
                 EnableA <= '1';
                 SourceB <= SReg2;
                 EnableB <= '1';
                 ALUcontrol <= OpCodeExt(3) & '1' & OpCodeExt(1 downto 0);
                 LoadCCR <= OpCodeExt(2);
                 EnableALU <= '1';
                 Dest <= DReg;
                 LoadDest <= '1';
                 FutureState <= Initial;

            --JMPC instruction
            when JMPCCODE =>
                 if CondHolds = '1' 
                 then
                    PCop <= INCRPC;
                    EnablePC <= '1';
                    ALUcontrol <= PASS_A;
                    EnableALU <= '1';
                    Dest <= DReg;
                    LoadDest <= '1';
                    FutureState <= GoTo;

                 else
                    FutureState <= Initial;
                 end if;
             

            --BRANCH instruction             
            when BRANCHCODE => 
                 if CondHolds = '1' 
                 then
                    EnableDisp <= '1';
                    PCop <= INCRPC;
                    EnablePC <= '1';
                    ALUcontrol <= ALU_ADD;
                    EnableALU <= '1';
                    PCop <= LOADPC;
                 end if;
                FutureState <= Initial;

            when others =>
                 FutureState <= Error;

          end case; --of OpCode

     when ReadData =>
          ReadMem <= '1';
          DriveCPU <= '1';
          Dest <= DReg; 
          LoadDest <= '1';

	  if mhold='1'
           then FutureState <= Initial;
  
          else FutureState <= ReadData;
         end if;

     when WriteData =>
          WriteMem <= '1';
          SourceA <= DReg;
          EnableA <= '1';
          ALUcontrol <= PASS_A;
          EnableALU <= '1';
          DriveMem <= '1';

	  if mhold='1'
           then FutureState <= Initial;
  
          else FutureState <= WriteData;
         end if;

     when GoTo =>
          SourceA <= SReg1;
          EnableA <= '1';
          SourceB <= SReg2;
          EnableB <= '1';
          ALUcontrol <= ALU_ADD;
          EnableALU <= '1';
          PCop <= LOADPC;
          FutureState <= Initial;

     when Halted => FutureState <= Halted;
     when others => FutureState <= Error;
   end case;         
  end process;
end architecture;

