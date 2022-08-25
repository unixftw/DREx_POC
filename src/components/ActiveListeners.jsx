import React from "react";
import styled from "styled-components";
import ecuador from "assets/ecuador.png";
import united from "assets/united.png";
import peru from "assets/peru.png";
import india from "assets/india.png";


export default function ActiveListeners() {
  const countries = [
    {
      name: "Ecuador",
      amount: 100,
      image: ecuador,
    },
    {
      name: "United States",
      amount: 0,
      image: united,
    },
    {
      name: "Peru",
      amount: 0,
      image: peru,
    },
    {
      name: "India",
      amount: 0,
      image: india,
    },
    
  ];
  return (
    <Section>
      <div className="title-container">
        <div className="title">
          <h4>Mini Grids Active Now</h4>
          <h1>1</h1>
        </div>
       
      </div>
      <div className="active">
        {countries.map((data, index) => {
          return (
            <div className="country" key={index}>
              <div className="name">
                <img src={data.image} alt={data.name} />
                <h5>{data.name}</h5>
              </div>
              <h5>{data.amount}%</h5>
            </div>
          );
        })}
      </div>
    </Section>
  );
}

const Section = styled.section`
  border-bottom: 0.1rem solid #242424;
  color: white;
  .title-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    width: 100%;
    padding-top: 1rem;
    .title {
      h4 {
        font-size: 0.8rem;
        margin-bottom: 0.2rem;
      }
      h1 {
        font-size: 1.5rem;
        letter-spacing: 0.2rem;
      }
    }
    .chart {
      position: relative;
      .percent {
        position: absolute;
        top: 0;
        left: 0;
        color: var(--primary-color);
        font-size: 0.8rem;
      }
      height: 4rem;
      width: 100%;
    }
  }
  .active {
    max-height: 11rem;
    overflow: auto;
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding-right: 1.5rem;
    margin: 1rem 0;
    ::-webkit-scrollbar {
      width: 0.2rem;
      background-color: #6e6e6ec3;
      &-thumb {
        background-color: #b8b8b8;
      }
    }
    h5 {
      font-weight: 100;
    }
    .country {
      display: flex;
      align-items: center;
      justify-content: space-between;
      .name {
        display: flex;
        gap: 1rem;
        align-items: center;
        img {
          height: 2rem;
          border-radius: 2rem;
        }
      }
    }
  }
`;
